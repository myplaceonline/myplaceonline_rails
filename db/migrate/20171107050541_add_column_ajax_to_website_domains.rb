class AddColumnAjaxToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :disable_ajax, :boolean
  end
end
