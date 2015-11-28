class AddCategoryFiltertextGas < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("gas_stations", "propane diesel fillup")
  end
end
