class CreatePlaylistSongs < ActiveRecord::Migration
  def change
    create_table :playlist_songs do |t|
      t.references :playlist, index: true
      t.references :song, index: true
      t.references :owner, index: true

      t.timestamps
    end
  end
end
