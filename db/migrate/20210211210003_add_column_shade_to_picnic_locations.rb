class AddColumnShadeToPicnicLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :picnic_locations, :shadedareas, :boolean
    add_column :picnic_locations, :treeshade, :boolean
  end
end
