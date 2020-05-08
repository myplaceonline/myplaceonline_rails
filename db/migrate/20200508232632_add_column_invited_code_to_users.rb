class AddColumnInvitedCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :used_invite_code, :text
  end
end
