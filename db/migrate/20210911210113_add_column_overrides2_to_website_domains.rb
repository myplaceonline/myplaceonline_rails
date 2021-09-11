class AddColumnOverrides2ToWebsiteDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :website_domains, :email_display_override, :string
  end
end
