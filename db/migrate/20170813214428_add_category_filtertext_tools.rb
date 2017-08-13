class AddCategoryFiltertextTools < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("tools", "gps")
  end
end
