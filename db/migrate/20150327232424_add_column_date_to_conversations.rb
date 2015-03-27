class AddColumnDateToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :when, :date
  end
end
