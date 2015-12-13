class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :playlist_name
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps
    end
  end
end
