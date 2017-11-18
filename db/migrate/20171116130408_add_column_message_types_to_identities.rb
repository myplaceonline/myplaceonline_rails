class AddColumnMessageTypesToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :message_preferences, :integer
  end
end
