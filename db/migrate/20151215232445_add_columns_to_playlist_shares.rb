class AddColumnsToPlaylistShares < ActiveRecord::Migration
  def change
    add_column :playlist_shares, :copy_self, :boolean
  end
end
