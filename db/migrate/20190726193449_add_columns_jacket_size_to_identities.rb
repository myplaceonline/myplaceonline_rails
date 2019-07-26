class AddColumnsJacketSizeToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :jacket_size, :text
  end
end
