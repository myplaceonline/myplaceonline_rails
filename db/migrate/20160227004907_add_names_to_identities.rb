class AddNamesToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :middle_name, :string
    add_column :identities, :last_name, :string
  end
end
