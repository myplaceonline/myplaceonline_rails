class SetRootUserType < ActiveRecord::Migration
  def change
    user = User.find(0)
    user.user_type = 1
    user.save!
  end
end
