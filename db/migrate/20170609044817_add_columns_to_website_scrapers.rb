class AddColumnsToWebsiteScrapers < ActiveRecord::Migration[5.1]
  def change
    add_column :website_scrapers, :content_type, :string
  end
end
