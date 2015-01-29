class RenameCreditCardColumns < ActiveRecord::Migration
  def change
    change_column :credit_cards, :number, :string
    change_column :credit_cards, :pin, :string
  end
end
