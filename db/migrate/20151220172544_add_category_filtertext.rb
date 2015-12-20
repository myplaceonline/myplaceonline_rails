class AddCategoryFiltertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("restaurants", "bars")
  end
end
