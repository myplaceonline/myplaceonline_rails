class FeedItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :feed

  validates :feed_title, presence: true
  validates :feed_link, presence: true
  
  def display
    feed_title
  end
end
