class CreateUsZipCodes < ActiveRecord::Migration
  def change
    create_table :us_zip_codes do |t|
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :county
      t.decimal :latitude, precision: 12, scale: 8
      t.decimal :longitude, precision: 12, scale: 8

      t.timestamps null: false
    end
  end
end
