class AddMypletsToExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if Myplet.where(owner: user.primary_identity).count == 0
        User.current_user = user
        Myplet.default_myplets(user.primary_identity)
        puts "Updated myplets for " + user.display
      end
    end
  end
end
