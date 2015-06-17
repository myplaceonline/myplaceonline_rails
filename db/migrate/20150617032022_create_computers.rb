class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.date :purchased
      t.decimal :price, precision: 10, scale: 2
      t.string :computer_model
      t.string :serial_number
      t.references :manufacturer, index: true
      t.integer :max_resolution_width
      t.integer :max_resolution_height
      t.integer :ram
      t.integer :num_cpus
      t.integer :num_cores_per_cpu
      t.boolean :hyperthreaded
      t.decimal :max_cpu_speed, precision: 10, scale: 2
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
