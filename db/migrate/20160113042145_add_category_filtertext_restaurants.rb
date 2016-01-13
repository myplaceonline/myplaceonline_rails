class AddCategoryFiltertextRestaurants < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("restaurants", "dessert")
  end
end
