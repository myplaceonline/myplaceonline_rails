class CreateWebsiteScrapers < ActiveRecord::Migration[5.1]
  def change
    create_table :website_scrapers do |t|
      t.string :scraper_name
      t.string :website_url
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
