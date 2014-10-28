class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :primary_identity, class_name: Identity
  
  attr_accessor :invite_code
  
  validates_each :invite_code, :on => :create do |record, attr, value|
    if Rails.configuration.require_invite_code
      record.errors.add attr, I18n.t("myplaceonline.users.invite_invalid") unless
        value && value == Rails.configuration.invite_code
    end
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
end
