class AddBestFriendThresholdToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :contact_best_friend_threshold, :integer
  end
end
