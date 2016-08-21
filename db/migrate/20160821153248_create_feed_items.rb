class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.string :feed_title
      t.references :feed, index: true, foreign_key: true
      t.string :feed_link
      t.text :content
      t.datetime :publication_date
      t.string :guid
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
