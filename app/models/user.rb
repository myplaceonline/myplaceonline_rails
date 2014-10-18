class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :primary_identity, class_name: Identity

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
end
