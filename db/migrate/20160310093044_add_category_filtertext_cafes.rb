class AddCategoryFiltertextCafes < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("cafes", "coffee shop")
  end
end
