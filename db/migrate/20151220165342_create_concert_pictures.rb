class CreateConcertPictures < ActiveRecord::Migration
  def change
    create_table :concert_pictures do |t|
      t.references :concert, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_foreign_key :concert_pictures, :identities, column: :owner_id
  end
end
