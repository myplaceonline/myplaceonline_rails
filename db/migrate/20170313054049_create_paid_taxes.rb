class CreatePaidTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :paid_taxes do |t|
      t.date :paid_tax_date
      t.decimal :donations, precision: 10, scale: 2
      t.decimal :federal_refund, precision: 10, scale: 2
      t.decimal :state_refund, precision: 10, scale: 2
      t.decimal :service_fee, precision: 10, scale: 2
      t.text :notes
      t.references :password, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
