class AddVehiclesFilter < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("vehicles", "truck")
  end
end
