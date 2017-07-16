class AddColumnsToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :verified, :boolean
    add_column :website_domains, :default_domain, :boolean
    add_column :website_domains, :meta_description, :string
    add_column :website_domains, :meta_keywords, :string
    add_column :website_domains, :hosts, :string
    add_column :website_domains, :static_homepage, :text
    add_column :website_domains, :menu_links_static, :text
    add_column :website_domains, :menu_links_logged_in, :text
  end
end
