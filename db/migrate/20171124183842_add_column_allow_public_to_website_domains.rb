class AddColumnAllowPublicToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :allow_public, :boolean
  end
end
