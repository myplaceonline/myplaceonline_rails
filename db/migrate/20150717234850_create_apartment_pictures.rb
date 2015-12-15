class CreateApartmentPictures < ActiveRecord::Migration
  def change
    create_table :apartment_pictures do |t|
      t.references :apartment, index: true
      t.references :identity_file, index: true
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
