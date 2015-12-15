class CreateBloodPressures < ActiveRecord::Migration
  def change
    create_table :blood_pressures do |t|
      t.integer :systolic_pressure
      t.integer :diastolic_pressure
      t.date :measurement_date
      t.string :measurement_source
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
