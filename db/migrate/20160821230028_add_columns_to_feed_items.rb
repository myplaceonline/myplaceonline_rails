class AddColumnsToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :read, :datetime
  end
end
