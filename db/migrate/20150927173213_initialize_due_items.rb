class InitializeDueItems < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if DueItem.where(owner: user.primary_identity).count == 0
        User.current_user = user
        DueItem.recalculate_due(user)
        puts "Updated due items for " + user.display
      end
    end
  end
end
