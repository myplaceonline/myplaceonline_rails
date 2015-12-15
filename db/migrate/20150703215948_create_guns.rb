class CreateGuns < ActiveRecord::Migration
  def change
    create_table :guns do |t|
      t.string :gun_name
      t.string :manufacturer_name
      t.string :gun_model
      t.decimal :bullet_caliber, precision: 10, scale: 2
      t.integer :max_bullets
      t.decimal :price, precision: 10, scale: 2
      t.date :purchased
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
