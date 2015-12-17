class AddColumns4ToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :todo_threshold, :integer
  end
end
