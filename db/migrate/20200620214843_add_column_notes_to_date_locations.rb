class AddColumnNotesToDateLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :date_locations, :notes, :text
  end
end
