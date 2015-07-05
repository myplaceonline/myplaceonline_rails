class CreateIdentityPictures < ActiveRecord::Migration
  def change
    create_table :identity_pictures do |t|
      t.references :ref, index: true
      t.references :identity_file, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
