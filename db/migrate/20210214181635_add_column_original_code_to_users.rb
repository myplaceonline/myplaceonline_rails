class AddColumnOriginalCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :origcode, :string
    change_column :users, :used_invite_code, :string
  end
end
