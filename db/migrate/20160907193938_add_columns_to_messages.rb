class AddColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :send_emails, :boolean
    add_column :messages, :send_texts, :boolean
  end
end
