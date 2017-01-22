class CreateChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :checks do |t|
      t.string :description
      t.text :notes
      t.decimal :amount, precision: 10, scale: 2
      t.references :contact, foreign_key: true
      t.references :company, foreign_key: true
      t.date :deposit_date
      t.date :received_date
      t.references :bank_account, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
