class AddColumns2ToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :time_from_home, :integer
  end
end
