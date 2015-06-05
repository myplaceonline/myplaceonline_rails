class AddCreditToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :total_credit, :decimal, precision: 10, scale: 2
  end
end
