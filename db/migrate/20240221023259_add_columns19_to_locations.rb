class AddColumns19ToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :googleplaceid, :string
  end
end
