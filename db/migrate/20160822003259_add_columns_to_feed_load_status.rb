class AddColumnsToFeedLoadStatus < ActiveRecord::Migration
  def change
    add_column :feed_load_statuses, :items_error, :integer
  end
end
