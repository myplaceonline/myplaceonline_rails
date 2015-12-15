class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :company, index: true
      t.integer :num_shares
      t.text :notes
      t.date :vest_date
      t.references :password, index: true
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
