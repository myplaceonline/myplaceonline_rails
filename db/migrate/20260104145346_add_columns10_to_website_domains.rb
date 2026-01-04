class AddColumns10ToWebsiteDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :website_domains, :handlesubdomains, :boolean
  end
end
