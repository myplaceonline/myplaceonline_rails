class SetDefaultIdentities < ActiveRecord::Migration[5.1]
  def change
    User.all.each do |user|
      identity = Identity.where(user_id: user.id).order("created_at ASC").take!
      identity.update_column(:website_domain_default, true)
    end
  end
end
