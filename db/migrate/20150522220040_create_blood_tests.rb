class CreateBloodTests < ActiveRecord::Migration
  def change
    create_table :blood_tests do |t|
      t.datetime :fast_started
      t.datetime :test_time
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
