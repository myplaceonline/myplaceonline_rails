class AddPositionToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :position, :integer
  end
end
