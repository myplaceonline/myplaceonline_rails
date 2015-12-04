class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_end_time, :datetime
    add_reference :events, :location, index: true
  end
end
