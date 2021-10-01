class AddColumnIsdisabledToIdentities < ActiveRecord::Migration[6.1]
  def change
    add_column :identities, :isdisabled, :boolean
  end
end
