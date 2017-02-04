class AddColumns5ToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :identity_type, :integer
  end
end
