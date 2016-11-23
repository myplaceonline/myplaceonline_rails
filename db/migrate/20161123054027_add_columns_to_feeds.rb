class AddColumnsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :total_items, :integer
    add_column :feeds, :unread_items, :integer
  end
end
