class CreateLifeInsurances < ActiveRecord::Migration
  def change
    create_table :life_insurances do |t|
      t.string :insurance_name
      t.references :company, index: true
      t.decimal :insurance_amount, precision: 10, scale: 2
      t.date :started
      t.references :periodic_payment, index: true
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
