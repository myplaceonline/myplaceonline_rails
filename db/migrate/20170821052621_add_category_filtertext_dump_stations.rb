class AddCategoryFiltertextDumpStations < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("gas_stations", "rv dump")
  end
end
