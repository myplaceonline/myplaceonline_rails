class CreateWebsiteScraperTransformations < ActiveRecord::Migration[5.1]
  def change
    create_table :website_scraper_transformations do |t|
      t.integer :transformation_type
      t.text :transformation
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true
      t.integer :position
      t.references :website_scraper, foreign_key: true

      t.timestamps
    end
  end
end
