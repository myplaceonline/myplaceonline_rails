class AddKtnToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :ktn, :string
  end
end
