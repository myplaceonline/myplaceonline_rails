class CreatePlaylistShares < ActiveRecord::Migration
  def change
    create_table :playlist_shares do |t|
      t.boolean :email
      t.references :playlist, index: true
      t.references :owner, index: true
      t.string :subject
      t.text :body

      t.timestamps null: true
    end
  end
end
