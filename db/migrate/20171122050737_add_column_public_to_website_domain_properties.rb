class AddColumnPublicToWebsiteDomainProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domain_properties, :is_public, :boolean
  end
end
