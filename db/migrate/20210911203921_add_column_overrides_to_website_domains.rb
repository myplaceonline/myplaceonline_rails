class AddColumnOverridesToWebsiteDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :website_domains, :email_name_override, :string
    add_column :website_domains, :email_host_override, :string
    add_column :website_domains, :secondary_email_name, :string
  end
end
