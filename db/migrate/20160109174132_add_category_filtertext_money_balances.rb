class AddCategoryFiltertextMoneyBalances < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("money_balances", "pay paid")
  end
end
