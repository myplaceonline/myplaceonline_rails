class AddColumnAjaxConfigToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :ajax_config, :integer
    remove_column :website_domains, :disable_ajax
  end
end
