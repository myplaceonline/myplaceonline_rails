class User < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  USER_TYPES = [
    ["myplaceonline.users.type_normal", 0],
    ["myplaceonline.users.type_admin", 1]
  ]
  
  GUEST_ID = -1
  GUEST_EMAIL = "guest@myplaceonline.com"

  TOP_LEFT_ICONS = [
    ["myplaceonline.users.top_left_icon_home", 0],
    ["myplaceonline.users.top_left_icon_back", 1]
  ]
  
  SUPPRESSION_MOBILE = 1
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :primary_identity, class_name: "Identity", :dependent => :destroy
  
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
  
  def self.guest
    result = User.new(
      id: GUEST_ID,
      email: GUEST_EMAIL,
      primary_identity_id: GUEST_ID
    )
    identity = Identity.new(
      id: GUEST_ID,
      user_id: GUEST_ID,
      user: result
    )
    result.primary_identity = identity
    result
  end
  
  def display
    email
  end

  # User loaded from database
  after_initialize do |user|
    # If user.id is nil, then it's an anonymous user
    if !user.id.nil? && primary_identity.nil?

      Rails.logger.debug{"Creating identity for #{user.id}"}
      
      ExecutionContext.root_or_push[:user] = user
      
      # No primary identity, so we create a default one. We can also do
      # any first-time initialization of the user here
      user.transaction do
        
        # Create the identity
        @identity = Identity.new
        @identity.user = user
        @identity.save!
        
        # Set the identity in the user
        user.primary_identity = @identity
        user.encrypt_by_default = true
        user.save!
        
        Rails.logger.debug{"Creating contact"}
        
        user.primary_identity.ensure_contact!
        
        Rails.logger.debug{"Creating myplets"}
        
        # Create default myplets
        Myplet.default_myplets(@identity)
        
        Rails.logger.debug{"Creating first status reminder"}
        
        Status.create_first_status
      end
    end
  end
  
  def total_points
    primary_identity.points.nil? ? 0 : primary_identity.points
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :primary_identity => primary_identity.as_json,
      :encrypted_values => encrypted_values.to_a.map{|x| x.as_json}
    })
  end
  
  def self.current_user
    MyplaceonlineExecutionContext.user
  end

  def self.current_user=(usr)
    MyplaceonlineExecutionContext.user = usr
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
    id == GUEST_ID
  end
  
  def has_emergency_contacts?
    primary_identity.emergency_contacts.count > 0
  end
  
  def send_sms(body)
    self.primary_identity.identity_phones.each do |identity_phone|
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
  
  def current_identity
    primary_identity
  end
  
  def current_identity_id
    primary_identity_id
  end
  
  def self.super_user
    User.find(0)
  end

  protected
    def confirmation_required?
      Rails.env.production?
    end
end
