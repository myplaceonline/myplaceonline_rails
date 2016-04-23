class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.string :tv_show_name
      t.text :notes
      t.datetime :watched
      t.string :url
      t.references :recommender, index: true, foreign_key: false
      t.string :tv_genre
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :tv_shows, :contacts, column: :recommender_id
  end
end
