class CreateMedicalConditionInstances < ActiveRecord::Migration
  def change
    create_table :medical_condition_instances do |t|
      t.datetime :condition_start
      t.datetime :condition_end
      t.text :notes
      t.references :medical_condition, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
