class AddCategoryFiltertext6 < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("permissions", "share")
  end
end
