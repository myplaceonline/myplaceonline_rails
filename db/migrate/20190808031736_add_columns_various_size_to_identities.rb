class AddColumnsVariousSizeToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :belt_size, :text
    add_column :identities, :tshirt_size, :text
  end
end
