class CreateCreditCardCashbacks < ActiveRecord::Migration
  def change
    create_table :credit_card_cashbacks do |t|
      t.references :identity, index: true
      t.references :credit_card, index: true
      t.references :cashback, index: true

      t.timestamps
    end
  end
end
