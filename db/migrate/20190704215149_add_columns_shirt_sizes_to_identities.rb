class AddColumnsShirtSizesToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :mens_shirt_neck_size, :string
    add_column :identities, :mens_shirt_sleeve_length, :string
  end
end
