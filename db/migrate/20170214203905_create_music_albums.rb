class CreateMusicAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :music_albums do |t|
      t.string :music_album_name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
