class AddColumns5ToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :vehicle_service_threshold, :integer
  end
end
