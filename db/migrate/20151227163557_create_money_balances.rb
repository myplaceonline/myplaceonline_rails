class CreateMoneyBalances < ActiveRecord::Migration
  def change
    create_table :money_balances do |t|
      t.references :contact, index: true, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.references :owner, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_foreign_key :money_balances, :identities, column: :owner_id
  end
end
