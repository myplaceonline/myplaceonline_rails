class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :model_name
      t.string :phone_number
      t.references :manufacturer, index: true
      t.date :purchased
      t.decimal :price, precision: 10, scale: 2
      t.integer :operating_system
      t.decimal :operating_system_version, precision: 10, scale: 2
      t.integer :max_resolution_width
      t.integer :max_resolution_height
      t.integer :ram
      t.integer :num_cpus
      t.integer :num_cores_per_cpu
      t.boolean :hyperthreaded
      t.decimal :max_cpu_speed, precision: 10, scale: 2
      t.boolean :cdma
      t.boolean :gsm
      t.decimal :front_camera_megapixels, precision: 10, scale: 2
      t.decimal :back_camera_megapixels, precision: 10, scale: 2
      t.text :notes
      t.references :owner, index: true
      t.references :password, index: true

      t.timestamps
    end
  end
end
