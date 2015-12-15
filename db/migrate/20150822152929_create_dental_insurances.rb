class CreateDentalInsurances < ActiveRecord::Migration
  def change
    create_table :dental_insurances do |t|
      t.string :insurance_name
      t.references :insurance_company, index: true
      t.boolean :defunct
      t.references :periodic_payment, index: true
      t.text :notes
      t.references :group_company, index: true
      t.references :password, index: true
      t.string :account_number
      t.string :group_number
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
