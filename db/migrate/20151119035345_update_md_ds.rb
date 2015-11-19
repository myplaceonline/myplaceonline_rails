class UpdateMdDs < ActiveRecord::Migration
  def change
    User.all.each do |user|
      User.current_user = user
      mdd = user.primary_identity.myplaceonline_due_displays[0]
      CompleteDueItem.where(owner: user.primary_identity).each do |x|
        x.myplaceonline_due_display = mdd
        x.save!
      end
      SnoozedDueItem.where(owner: user.primary_identity).each do |x|
        x.myplaceonline_due_display = mdd
        x.save!
      end
      puts "Updated due items for " + user.display
    end
  end
end
