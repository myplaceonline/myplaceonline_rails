class AddColumns2ToWebsiteDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :website_domains, :skipterms, :boolean
  end
end
