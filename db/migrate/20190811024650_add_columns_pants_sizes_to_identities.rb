class AddColumnsPantsSizesToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :pants_waist, :string
    add_column :identities, :pants_length, :string
  end
end
