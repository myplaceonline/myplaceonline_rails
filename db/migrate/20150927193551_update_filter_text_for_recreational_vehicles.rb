class UpdateFilterTextForRecreationalVehicles < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("recreational_vehicles", "campers")
  end
end
