class CreateMoneyBalanceItems < ActiveRecord::Migration
  def change
    create_table :money_balance_items do |t|
      t.references :money_balance, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: false
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :item_time
      t.string :money_balance_item_name
      t.text :notes

      t.timestamps null: false
    end
    add_foreign_key :money_balance_items, :identities, column: :owner_id
  end
end
