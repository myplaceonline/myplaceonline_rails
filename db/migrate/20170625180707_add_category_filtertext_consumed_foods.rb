class AddCategoryFiltertextConsumedFoods < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("consumed_foods", "eat breakfast lunch dinner snack")
  end
end
