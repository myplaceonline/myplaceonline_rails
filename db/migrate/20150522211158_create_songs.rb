class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :song_name
      t.decimal :song_rating, precision: 10, scale: 2
      t.text :lyrics
      t.integer :song_plays
      t.datetime :lastplay
      t.boolean :secret
      t.boolean :awesome
      t.references :identity, index: true

      t.timestamps
    end
  end
end
