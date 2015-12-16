class AddColumns3ToPlaylistShares < ActiveRecord::Migration
  def change
    add_reference :playlist_shares, :share, index: true, foreign_key: true
  end
end
