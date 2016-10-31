class UpdateFilterTextForCategoryPerishableFoods < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("perishable_foods", "canned")
  end
end
