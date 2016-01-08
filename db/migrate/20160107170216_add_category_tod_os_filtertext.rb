class AddCategoryTodOsFiltertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("to_dos", "reminder")
  end
end
