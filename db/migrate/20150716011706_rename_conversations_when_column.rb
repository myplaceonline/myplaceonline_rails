class RenameConversationsWhenColumn < ActiveRecord::Migration
  def change
    rename_column :conversations, :when, :conversation_date
  end
end
