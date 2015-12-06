class CreateRootUser < ActiveRecord::Migration
  def up
    user = User.new
    user.id = 0
    user.email = ENV["ROOT_EMAIL"].blank? ? Myplaceonline::DEFAULT_SUPPORT_EMAIL : ENV["ROOT_EMAIL"]
    user.password = ENV["ROOT_PASSWORD"].blank? ? "password" : ENV["ROOT_PASSWORD"]
    user.password_confirmation = user.password
    user.confirmed_at = Time.now
    user.save(:validate => false)

    User.current_user = user
      
    identity = Identity.new
    identity.id = 0
    identity.owner = user
    identity.save!
        
    user.primary_identity = identity
    user.save!
        
    Myplet.default_myplets(identity)
        
    puts User.find(0).inspect
  end

  def down
    User.find(0).destroy!
  end
end
