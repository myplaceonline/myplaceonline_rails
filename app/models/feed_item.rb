class FeedItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern

  belongs_to :feed

  boolean_time_transfer :is_read, :read

  validates :feed_title, presence: true
  validates :feed_link, presence: true
  
  def display
    feed_title
  end
end
