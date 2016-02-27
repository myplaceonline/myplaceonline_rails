class RemoveEmailColumns < ActiveRecord::Migration
  def change
    remove_column :permission_shares, :email
  end
end
