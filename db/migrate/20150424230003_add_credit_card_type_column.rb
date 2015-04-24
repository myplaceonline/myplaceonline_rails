class AddCreditCardTypeColumn < ActiveRecord::Migration
  def change
    add_column :credit_cards, :card_type, :integer
  end
end
