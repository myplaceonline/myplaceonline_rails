class CreateRecreationalVehicleLoans < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_loans do |t|
      t.references :recreational_vehicle, index: true
      t.references :loan, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
