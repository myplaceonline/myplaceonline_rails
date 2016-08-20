class User < ActiveRecord::Base
  include MyplaceonlineActiveRecordBaseConcern

  USER_TYPES = [
    ["myplaceonline.users.type_normal", 0],
    ["myplaceonline.users.type_admin", 1]
  ]
  
  GUEST_ID = -1
  GUEST_EMAIL = "guest@myplaceonline.com"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :primary_identity, class_name: Identity, :dependent => :destroy
  
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
    User.new(
      id: GUEST_ID,
      email: GUEST_EMAIL,
      primary_identity_id: GUEST_ID,
      primary_identity: Identity.new(
        id: GUEST_ID
      )
    )
  end
  
  def display
    email
  end

  # User loaded from database
  after_initialize do |user|
    # If user.id is nil, then it's an anonymous user
    if !user.id.nil? && primary_identity.nil?

      User.current_user = user
      
      # No primary identity, so we create a default one. We can also do
      # any first-time initialization of the user here
      user.transaction do
        
        # Create the identity
        @identity = Identity.new
        @identity.user = user
        @identity.save!
        
        # Set the identity in the user
        user.primary_identity = @identity
        user.save!
        
        # Create default myplets
        Myplet.default_myplets(@identity)
        
        Status.new.on_after_destroy
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
    Thread.current[:current_user]
  end

  def self.current_user=(usr)
    Thread.current[:current_user] = usr
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

  protected
    def confirmation_required?
      Rails.env.production?
    end
end
