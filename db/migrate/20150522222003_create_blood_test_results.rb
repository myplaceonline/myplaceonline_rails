class CreateBloodTestResults < ActiveRecord::Migration
  def change
    create_table :blood_test_results do |t|
      t.references :blood_test, index: true
      t.references :blood_concentration, index: true
      t.decimal :concentration, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
