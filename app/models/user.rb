class User < MyplaceonlineModelBase

  USER_TYPES = [
    ["myplaceonline.users.type_normal", 0],
    ["myplaceonline.users.type_admin", 1]
  ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :primary_identity, class_name: Identity, :dependent => :destroy
  
  has_many :encrypted_values, :dependent => :destroy
  
  attr_accessor :invite_code
  
  validates_each :invite_code, :on => :create do |record, attr, value|
    if Rails.configuration.require_invite_code
      record.errors.add attr, I18n.t("myplaceonline.users.invite_invalid") unless
        value && value == Rails.configuration.invite_code
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
    # If user.id is nil, then it's an anonymous user
    if !user.id.nil? && primary_identity.nil?
      # No primary identity, so we create a default one
      user.transaction do
        @identity = Identity.new
        @identity.owner = user
        @identity.save
        user.primary_identity = @identity
        user.save
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
end
