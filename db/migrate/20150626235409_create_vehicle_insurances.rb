class CreateVehicleInsurances < ActiveRecord::Migration
  def change
    create_table :vehicle_insurances do |t|
      t.string :insurance_name
      t.references :company, index: true
      t.date :started
      t.references :periodic_payment, index: true
      t.references :vehicle, index: true
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
