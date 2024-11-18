class FeedItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern

  belongs_to :feed

  boolean_time_transfer :is_read, :read

  validates :feed_title, presence: true
  validates :feed_link, presence: true
  
  def display
    feed_title
  end
  
  def display_icon
    Myp.categories["feeds"].icon
  end
  
  def ideal_path
    "/feeds/#{feed.id}/feed_items/#{self.id}"
  end

  after_commit :on_after_update, on: [:update, :destroy]

  def on_after_update
    if !self.feed.nil?
      self.feed.reset_counts
    end
  end
  
  def full_feed_link
    result = feed_link
    if !result.blank? && result[0] == '/'
      uri = URI.parse(feed.url)
      result = URI.join(uri.scheme + "://" + uri.host, result).to_s
    end
    result
  end

  def self.skip_check_attributes
    ["is_read"]
  end
  
  def self.searchable?
    return false
  end
end
