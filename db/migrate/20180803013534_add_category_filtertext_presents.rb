class AddCategoryFiltertextPresents < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("presents", "birthday cards gifts")
  end
end
