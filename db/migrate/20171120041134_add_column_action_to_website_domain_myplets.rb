class AddColumnActionToWebsiteDomainMyplets < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domain_myplets, :action, :string
  end
end
