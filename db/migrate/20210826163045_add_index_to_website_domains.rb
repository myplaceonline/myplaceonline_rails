class AddIndexToWebsiteDomains < ActiveRecord::Migration[6.1]
  def change
    add_index :website_domains, :verified
  end
end
