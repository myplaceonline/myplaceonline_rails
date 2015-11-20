class AddColumnsToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :contact_good_friend_threshold, :integer
    add_column :myplaceonline_due_displays, :contact_acquaintance_threshold, :integer
    add_column :myplaceonline_due_displays, :contact_best_family_threshold, :integer
    add_column :myplaceonline_due_displays, :contact_good_family_threshold, :integer
  end
end
