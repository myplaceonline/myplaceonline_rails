class CreateRecreationalVehicleInsurances < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_insurances do |t|
      t.string :insurance_name
      t.references :company, index: true
      t.date :started
      t.references :periodic_payment, index: true
      t.text :notes
      t.references :recreational_vehicle
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
