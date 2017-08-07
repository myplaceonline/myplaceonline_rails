class AddColumnsToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :long_body, :text
    add_column :messages, :send_preferences, :integer
    remove_column :messages, :send_emails
    remove_column :messages, :send_texts
  end
end
