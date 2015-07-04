class AddNickNameToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :nickname, :string
  end
end
