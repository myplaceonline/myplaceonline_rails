class AddColumnHomepagePathCachedToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :homepage_path_cached, :boolean
  end
end
