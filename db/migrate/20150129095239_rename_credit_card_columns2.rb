class RenameCreditCardColumns2 < ActiveRecord::Migration
  def change
    change_column :credit_cards, :security_code, :string
  end
end
