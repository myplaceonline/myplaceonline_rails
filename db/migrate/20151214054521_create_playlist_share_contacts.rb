class CreatePlaylistShareContacts < ActiveRecord::Migration
  def change
    create_table :playlist_share_contacts do |t|
      t.references :playlist_share, index: true
      t.references :contact, index: true
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
