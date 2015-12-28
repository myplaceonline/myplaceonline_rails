class AddCategoryFiltertext5 < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("money_balances", "lend owe rent")
  end
end
