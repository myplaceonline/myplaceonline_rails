class CreateWebComics < ActiveRecord::Migration
  def change
    create_table :web_comics do |t|
      t.string :web_comic_name
      t.references :website, index: true, foreign_key: true
      t.references :feed, index: true, foreign_key: true
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
