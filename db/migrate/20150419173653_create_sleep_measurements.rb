class CreateSleepMeasurements < ActiveRecord::Migration
  def change
    create_table :sleep_measurements do |t|
      t.datetime :sleep_start_time
      t.datetime :sleep_end_time
      t.references :identity, index: true

      t.timestamps
    end
  end
end
