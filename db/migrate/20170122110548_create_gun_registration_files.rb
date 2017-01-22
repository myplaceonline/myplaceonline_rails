class CreateGunRegistrationFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :gun_registration_files do |t|
      t.references :gun_registration, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
