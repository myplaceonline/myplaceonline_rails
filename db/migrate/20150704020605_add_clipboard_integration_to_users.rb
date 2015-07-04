class AddClipboardIntegrationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clipboard_integration, :integer
  end
end
