class CreatePassportPictures < ActiveRecord::Migration
  def change
    create_table :passport_pictures do |t|
      t.references :passport, index: true
      t.references :identity_file, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
