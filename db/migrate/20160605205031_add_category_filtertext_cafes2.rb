class AddCategoryFiltertextCafes2 < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("cafes", "cafe")
  end
end
