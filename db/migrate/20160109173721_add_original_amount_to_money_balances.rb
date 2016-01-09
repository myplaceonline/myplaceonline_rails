class AddOriginalAmountToMoneyBalances < ActiveRecord::Migration
  def change
    add_column :money_balance_items, :original_amount, :decimal, precision: 10, scale: 2
  end
end
