class AddCategoryFiltertextDiscounts < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("promotions", "discounts")
  end
end
