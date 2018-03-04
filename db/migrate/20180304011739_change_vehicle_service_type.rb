class ChangeVehicleServiceType < ActiveRecord::Migration[5.1]
  def change
    change_column :vehicle_services, :service_location, :string
  end
end
