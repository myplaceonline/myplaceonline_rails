class AddColumnCoalDisposalToPicnicLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :picnic_locations, :coal_disposal, :boolean
  end
end
