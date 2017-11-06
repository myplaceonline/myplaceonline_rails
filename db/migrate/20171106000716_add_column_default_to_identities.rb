class AddColumnDefaultToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :website_domain_default, :boolean
  end
end
