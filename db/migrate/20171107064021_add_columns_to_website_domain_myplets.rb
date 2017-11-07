class AddColumnsToWebsiteDomainMyplets < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domain_myplets, :singleton, :boolean
    add_column :website_domain_myplets, :emulate_guest, :boolean
  end
end
