class AddCategoryFiltertextExports < ActiveRecord::Migration[5.2]
  def change
    Myp.migration_add_filtertext("exports", "backup offline archive save")
  end
end
