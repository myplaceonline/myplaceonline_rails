class AddCategoryFiltertextSicknesses < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("sicknesses", "cold fever")
  end
end
