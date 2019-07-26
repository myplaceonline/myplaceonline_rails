class AddColumnsShoeSizeToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :shoe_size, :text
  end
end
