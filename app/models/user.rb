class User < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  USER_TYPE_NORMAL = 0
  USER_TYPE_ADMIN = 1
  
  USER_TYPES = [
    ["myplaceonline.users.type_normal", USER_TYPE_NORMAL],
    ["myplaceonline.users.type_admin", USER_TYPE_ADMIN]
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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :identities, :dependent => :destroy
  
  def domain_identities
    domain = Myp.website_domain
    identities.order(:name).to_a.dup.keep_if { |x| x.website_domain.id == domain.id }
  end
  
  def self.current_user
    MyplaceonlineExecutionContext.user
  end

  def current_identity_id
    result = nil
    i = self.current_identity
    if !i.nil?
      result = i.id
    end
    result
  end
  
  def current_identity
    #Rails.logger.debug{"User.current_identity user_id: #{self.id}"}
    result = nil
    if ExecutionContext.available?
      result = MyplaceonlineExecutionContext.identity
    end
    if result.nil?
      result = self.domain_identity
    else
      if result.user_id != self.id
        # This can happen if an identity is emulated (e.g. website domain homepage)
        #raise "Unexpected identity #{result.id} for user #{self.id}"
      end
    end
    #Rails.logger.debug{"User.current_identity returning: #{result.nil? ? nil : result.id}"}
    result
  end
  
  def domain_identity
    Rails.logger.debug{"User.domain_identity user_id: #{self.id}"}
    result = nil
    if self.id != GUEST_USER_ID
      domain = Myp.website_domain
      if !domain.nil?
        domain_id = domain.id
        identity_index = self.identities.find_index do |identity|
          identity.website_domain_id == domain_id && identity.website_domain_default
        end
        if !identity_index.nil?
          result = self.identities[identity_index]
        end
      end
    else
      result = Identity.new(
        id: GUEST_USER_IDENTITY_ID,
        user_id: GUEST_USER_ID,
        user: self,
      )
    end
    Rails.logger.debug{"User.domain_identity returning: #{result.nil? ? nil : result.id}"}
    result
  end
  
  def change_default_identity(identity)
    domain_id = Myp.website_domain.id
    Identity.where(user_id: self.id, website_domain_id: domain_id).update_all(website_domain_default: false)
    Identity.where(user_id: self.id, website_domain_id: domain_id, id: identity.id).update_all(website_domain_default: true)
    self.identities.reload
  end
  
  has_many :encrypted_values, :dependent => :destroy
  
  attr_accessor :invite_code
  
  validates_each :invite_code, :on => :create do |record, attr, value|
    if Myp.requires_invite_code
      if !InviteCode.valid_code?(value)
        record.errors.add attr, I18n.t("myplaceonline.users.invite_invalid")
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
    User.post_initialize(user)
  end

  def self.post_initialize(user)
      
    # If user.id is nil, then it's an anonymous user
    if !user.id.nil? && user.current_identity_id.nil?
      
      MyplaceonlineExecutionContext.do_user(user) do
        Rails.logger.debug{"Creating identity for #{user.id}"}
        
        # No identity for the current domain, so we create a default one. We can
        # also do any first-time initialization of the user here
        user.transaction do
          
          if user.identities.count == 0
            user.encrypt_by_default = true
            user.save!
          end
          
          # Create the identity
          new_identity = Identity.new
          new_identity.user = user
          new_identity.name = Identity.email_to_name(user.email)
          new_identity.save!

          User.post_initialize_identity(user, new_identity)
        end
      end

    end
  end
  
  def self.post_initialize_identity(user, identity)
    # We do a direct update because this identity doesn't own the website
    # domain object
    identity.update_column(:website_domain_id, Myp.website_domain.id)
    identity.reload
    
    MyplaceonlineExecutionContext.do_identity(identity) do
      user.change_default_identity(identity)
      user.identities.reload
      
      identity.after_create
      
      Rails.logger.debug{"Creating first status reminder"}
      
      Status.create_first_status
    end
  end
  
  def total_points
    current_identity.points.nil? ? 0 : current_identity.points
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :current_identity => current_identity.as_json,
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

  after_commit :on_after_create, on: [:create]
  
  def on_after_create
    if Myp.requires_invite_code && !invite_code.nil? # Users can be created outside the web process
      InviteCode.increment_code(invite_code)
    end
  end
  
  def guest?
    id == GUEST_USER_ID
  end
  
  def has_emergency_contacts?
    current_identity.emergency_contacts.count > 0
  end
  
  def send_sms(body)
    self.current_identity.identity_phones.each do |identity_phone|
      if identity_phone.accepts_sms?
        Myp.send_sms(to: identity_phone.number, body: body)
      end
    end
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
  
  protected
    def confirmation_required?
      Rails.env.production?
    end
end
