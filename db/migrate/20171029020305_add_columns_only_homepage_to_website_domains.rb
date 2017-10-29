class AddColumnsOnlyHomepageToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :only_homepage, :boolean
  end
end
