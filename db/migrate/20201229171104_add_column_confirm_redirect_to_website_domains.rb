class AddColumnConfirmRedirectToWebsiteDomains < ActiveRecord::Migration[5.2]
  def change
    add_column :website_domains, :confirm_redirect, :string
  end
end
