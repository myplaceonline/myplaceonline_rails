class CreatePhoneFiles < ActiveRecord::Migration
  def change
    create_table :phone_files do |t|
      t.references :phone, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
