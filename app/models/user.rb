class User < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  USER_TYPE_NORMAL = 0
  USER_TYPE_ADMIN = 1
  USER_TYPE_DEMO = 2
  
  USER_TYPES = [
    ["myplaceonline.users.type_normal", USER_TYPE_NORMAL],
    ["myplaceonline.users.type_admin", USER_TYPE_ADMIN],
    ["myplaceonline.users.type_demo", USER_TYPE_DEMO],
  ]
  
  # The guest user will not exist in the database
  GUEST_USER_ID = -1
  GUEST_USER_IDENTITY_ID = -1
  DEFAULT_GUEST_EMAIL = "guest@myplaceonline.com"
  
  SUPER_USER_ID = 0
  SUPER_USER_IDENTITY_ID = 0
  DEFAULT_SUPER_USER_EMAIL = "root@myplaceonline.com"
  
  TOP_LEFT_ICONS = [
    ["myplaceonline.users.top_left_icon_home", 0],
    ["myplaceonline.users.top_left_icon_back", 1]
  ]
  
  SUPPRESSION_MOBILE = 1

  def self.guest
    User.new(
      id: GUEST_USER_ID,
      email: DEFAULT_GUEST_EMAIL,
    )
  end
  
  def self.super_user
    User.find(SUPER_USER_ID)
  end
  
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :destroy # or :delete_all if you don't need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :destroy # or :delete_all if you don't need callbacks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :doorkeeper

  has_many :identities, :dependent => :destroy

  has_many :entered_invite_codes, :dependent => :destroy
  
  def domain_identities
    domain = Myp.website_domain
    identities.order(:name).to_a.dup.keep_if { |x| x.website_domain_id == domain.id }
  end
  
  def self.current_user
    MyplaceonlineExecutionContext.user
  end

  # This should only be called if the currently logged in user is this user
  def current_identity_id
    result = nil
    i = self.current_identity
    if !i.nil?
      result = i.id
    end
    result
  end
  
  # This should only be called if the currently logged in user is this user
  def current_identity
    #::Rails.logger.debug{"User.current_identity user_id: #{self.id}"}
    result = nil
    if ExecutionContext.available?
      #::Rails.logger.debug{"User.current_identity getting execution context identity"}
      result = MyplaceonlineExecutionContext.identity
    end
    if result.nil?
      #::Rails.logger.debug{"User.current_identity getting domain_identity"}
      result = self.domain_identity
    else
      if result.user_id != self.id
        # This can happen if an identity is emulated (e.g. website domain homepage)
      end
    end
    #::Rails.logger.debug{"User.current_identity returning: #{result.nil? ? nil : result.id}"}
    result
  end
  
  def domain_identity
    result = nil
    if self.id != GUEST_USER_ID
      domain = Myp.website_domain
      if !domain.nil?
        #::Rails.logger.debug{"User.domain_identity checking domain #{domain.id}"}
        domain_id = domain.id
        temp_identity_id = nil
        if ExecutionContext.available?
          temp_identity_id = MyplaceonlineExecutionContext[:temp_identity_id]
        end
        if temp_identity_id.nil?
          #::Rails.logger.debug{"User.domain_identity checking user identities"}
          identity_index = self.identities.find_index do |identity|
            identity.website_domain_id == domain_id && identity.website_domain_default
          end
        else
          #::Rails.logger.debug{"User.domain_identity checking for temp identity"}
          identity_index = self.identities.find_index do |identity|
            identity.website_domain_id == domain_id && identity.id == temp_identity_id
          end
        end
        if !identity_index.nil?
          #::Rails.logger.debug{"User.domain_identity getting based on index"}
          result = self.identities[identity_index]
        end
      end
    else
      #::Rails.logger.debug{"User.domain_identity creating guest identity"}
      result = Identity.new(
        id: GUEST_USER_IDENTITY_ID,
        user_id: GUEST_USER_ID,
        user: self,
      )
    end
    result
  end
  
  def change_default_identity(identity)
    domain_id = Myp.website_domain.id
    Identity.where(user_id: self.id, website_domain_id: domain_id).update_all(website_domain_default: false)
    Identity.where(user_id: self.id, website_domain_id: domain_id, id: identity.id).update_all(website_domain_default: true)
    self.identities.reload
  end
  
  has_many :encrypted_values, :dependent => :destroy
  has_many :notification_registrations, :dependent => :destroy
  
  attr_accessor :invite_code
  
  validates_each :invite_code, :on => :create do |record, attr, value|
    if Myp.requires_invite_code
      if !InviteCode.valid_code?(value)
        record.errors.add(attr, I18n.t("myplaceonline.users.invite_invalid"))
      end
    end
  end
  
  after_commit :on_after_create, on: [:create]
  
  def on_after_create
    if Myp.requires_invite_code && !invite_code.nil? && !MyplaceonlineExecutionContext.offline? # Users can be created outside the web process

      # Save off the entered invite code for post_initialize
      entered_invite_code = EnteredInviteCode.new(
        user_id: self.id,
        website_domain_id: Myp.website_domain.id,
      )
      entered_invite_code.internal = true
      entered_invite_code.code = self.invite_code
      entered_invite_code.saved_invite_code = self.invite_code
      entered_invite_code.save!
      
      InviteCode.increment_code(invite_code)
      
      if !InviteCode.valid_code?(invite_code)
        # Invite code has reached the maximum
        Myp.send_support_email_safe(
          "Invite code #{invite_code} has been exhausted",
          "Invite code #{invite_code} has been exhausted",
          "Invite code #{invite_code} has been exhausted",
        )
      end
    end
  end
  
  def admin?
    if !user_type.nil? && (user_type & 1) != 0
      true
    else
      false
    end
  end
  
  def display
    email
  end

  # User loaded from database
  after_initialize do |user|
    user.post_initialize
  end

  def post_initialize
    if self.needs_identity? && !MyplaceonlineExecutionContext.offline?
      MyplaceonlineExecutionContext.do_user(self) do
        # If the domain requires an invite code, then redirect
        website_domain = Myp.website_domain
        
        create_identity = self.check_invite_code(website_domain, false)
        
        if create_identity
          ::Rails.logger.debug{"Creating identity for #{self.id} and domain #{website_domain.id}"}
          
          # No identity for the current domain, so we create a default one. We can
          # also do any first-time initialization of the user here
          self.transaction do
            
            if self.identities.count == 0
              self.encrypt_by_default = true
              self.save!
            end
            
            # Create the identity
            new_identity = Identity.new
            new_identity.user = self
            new_identity.name = Identity.email_to_name(self.email)
            new_identity.save!

            self.post_initialize_identity(new_identity)
          end
        end
      end
    end
  end
  
  def needs_identity?
    !self.id.nil? && self.domain_identity.nil?
  end
  
  def check_invite_code(website_domain, redirect)
    create_identity = true
    
    if Myp.requires_invite_code && !website_domain.allow_public?
      ::Rails.logger.debug{"Domain requires invite code for user #{self}"}
      
      code = EnteredInviteCode.where(user: self, website_domain: website_domain).take

      ::Rails.logger.debug{"User has code: #{code.inspect}"}

      if code.nil?
        create_identity = false
        if !MyplaceonlineExecutionContext.request_uri.nil? && !MyplaceonlineExecutionContext.request_uri.starts_with?("/entered_invite_codes/")
          if redirect
            raise Myp::SuddenRedirectError.new("/entered_invite_codes/new", I18n.t("myplaceonline.entered_invite_codes.code_required"))
          end
        end
      else
        # Save off the code
        if !code.saved_invite_code.blank?
          self.used_invite_code = code.saved_invite_code.downcase
        end
        if !code.saved_invite_code.blank?
          self.origcode = code.saved_invite_code.downcase
        end
        self.save!

        code.destroy!
      end
    end
    
    create_identity
  end
  
  def post_initialize_identity(identity)
    # We do a direct update because this identity doesn't own the website
    # domain object
    identity.update_column(:website_domain_id, Myp.website_domain.id)
    identity.reload
    
    MyplaceonlineExecutionContext.do_identity(identity) do
      self.change_default_identity(identity)
      self.identities.reload
      
      identity.after_create
      
      ::Rails.logger.debug{"Creating first status reminder"}
      
      Status.create_first_status
    end
  end
  
  # This should only be called if the currently logged in user is this user
  def total_points
    current_identity.points.nil? ? 0 : current_identity.points
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :encrypted_values => encrypted_values.to_a.map{|x| x.as_json}
    })
  end
  
  def time_now
    result = Time.now
    if !timezone.blank?
      result = ActiveSupport::TimeZone[timezone].now
    end
    result
  end

  def date_now
    result = Date.today
    if !timezone.blank?
      result = ActiveSupport::TimeZone[timezone].today
    end
    result
  end
  
  def in_time_zone(x, end_of_day: false)
    result = x
    if !timezone.blank?
      result = result.in_time_zone(self.timezone)
    end
    if end_of_day && x.is_a?(Date)
      result = result.to_datetime + 1.day - 1.second
    end
    result
  end

  def guest?
    id == GUEST_USER_ID
  end
  
  # This should only be called if the currently logged in user is this user
  def has_emergency_contacts?
    current_identity.emergency_contacts.count > 0
  end
  
  def suppresses(which)
    !self.suppressions.nil? && (self.suppressions & which) != 0
  end
  
  def has_encrypted_content?
    EncryptedValue.where(user_id: self.id).count > 0
  end
  
  def get_encryption_mode
    result = Myp::ENCRYPTION_MODE_DEFAULT
    if !self.encryption_mode.nil?
      result = self.encryption_mode
    end
    result
  end
  
  def send_email?
    self.domain_identity.send_email?
  end
  
  def send_text?
    self.domain_identity.send_text?
  end
  
  def send_message(body_short_markdown, body_long_markdown, subject, reply_to: nil, cc: nil, bcc: nil)
    self.domain_identity.send_message(body_short_markdown, body_long_markdown, subject, reply_to: reply_to, cc: cc, bcc: bcc)
  end
  
  def send_email(subject, body, cc = nil, bcc = nil, body_plain = nil, reply_to = nil)
    self.domain_identity.send_email(subject, body, cc, bcc, body_plain, reply_to)
  end

  def send_sms(body)
    self.domain_identity.send_sms(body: body)
  end
  
  def update_tracked_fields!(request)
    ::Rails.logger.debug{"User.update_tracked_fields! #{self.id} offline: #{MyplaceonlineExecutionContext.offline?}"}
    if !MyplaceonlineExecutionContext.offline?
      super(request)
    else
      nil
    end
  end
  
  def demo_user?
    return self.user_type == USER_TYPE_DEMO
  end
  
  protected
    def confirmation_required?
      #::Rails.env.production? && !self.demo_user?
      false
    end
end
