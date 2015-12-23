class AddCategoryFiltertext2 < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("date_locations", "dates")
  end
end
