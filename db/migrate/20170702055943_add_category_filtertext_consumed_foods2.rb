class AddCategoryFiltertextConsumedFoods2 < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("consumed_foods", "meals")
  end
end
