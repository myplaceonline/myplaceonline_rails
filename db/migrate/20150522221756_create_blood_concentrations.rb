class CreateBloodConcentrations < ActiveRecord::Migration
  def change
    create_table :blood_concentrations do |t|
      t.string :concentration_name
      t.integer :concentration_type
      t.decimal :concentration_minimum, precision: 10, scale: 2
      t.decimal :concentration_maximum, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps
    end
  end
end
