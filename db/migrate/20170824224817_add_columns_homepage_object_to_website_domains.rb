class AddColumnsHomepageObjectToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :homepage_path, :string
  end
end
