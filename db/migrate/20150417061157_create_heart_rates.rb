class CreateHeartRates < ActiveRecord::Migration
  def change
    create_table :heart_rates do |t|
      t.integer :beats
      t.date :measurement_date
      t.string :measurement_source
      t.references :identity, index: true

      t.timestamps
    end
  end
end
