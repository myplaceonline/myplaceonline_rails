class CreateMoneyBalanceItemTemplates < ActiveRecord::Migration
  def change
    create_table :money_balance_item_templates do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :original_amount, precision: 10, scale: 2
      t.string :money_balance_item_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true
      t.references :money_balance, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
