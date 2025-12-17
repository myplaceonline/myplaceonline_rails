class AddColumnsToDateLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :date_locations, :context, :string
  end
end
