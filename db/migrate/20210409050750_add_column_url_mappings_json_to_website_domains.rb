class AddColumnUrlMappingsJsonToWebsiteDomains < ActiveRecord::Migration[5.2]
  def change
    add_column :website_domains, :url_mappings_json, :text
  end
end
