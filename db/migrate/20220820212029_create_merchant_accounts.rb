class CreateMerchantAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :merchant_accounts do |t|
      t.string :merchant_account_name
      t.decimal :limit_daily, precision: 10, scale: 2
      t.decimal :limit_monthly, precision: 10, scale: 2
      t.text :currencies_accepted
      t.text :ship_to_countries
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
