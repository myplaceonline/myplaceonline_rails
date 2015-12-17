class AddColumns4ToPlaylistShares < ActiveRecord::Migration
  def change
    add_column :playlist_shares, :visit_count, :integer
  end
end
