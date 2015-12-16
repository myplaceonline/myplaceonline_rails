class AddColumns2ToPlaylistShares < ActiveRecord::Migration
  def change
    add_reference :playlists, :identity_file, index: true, foreign_key: true
  end
end
