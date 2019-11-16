class AddColumnRvsToVehicleWashes < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_washes, :rvs, :boolean
  end
end
