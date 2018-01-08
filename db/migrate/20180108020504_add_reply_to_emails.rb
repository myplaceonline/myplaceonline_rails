class AddReplyToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :reply_to, :string
    add_column :messages, :reply_to, :string
    add_column :emails, :suppress_context_info, :boolean
    add_column :messages, :suppress_context_info, :boolean
  end
end
