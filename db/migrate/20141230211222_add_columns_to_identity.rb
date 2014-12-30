class AddColumnsToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :name, :string
  end
end
