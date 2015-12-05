class AddColumns3ToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :event_threshold, :integer
    add_column :myplaceonline_due_displays, :stocks_vest_threshold, :integer
  end
end
