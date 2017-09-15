class AddColumnRssFeedToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :feed_url, :string
  end
end
