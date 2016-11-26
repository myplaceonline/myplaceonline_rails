class ResetBadFeedItems < ActiveRecord::Migration
  def change
    FeedItem.destroy_all(publication_date: nil)
  end
end
