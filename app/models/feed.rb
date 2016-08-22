class Feed < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :url, presence: true
  
  has_many :feed_items, -> { order('publication_date DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :feed_items, allow_destroy: true, reject_if: :all_blank

  def display
    name
  end
  
  def load_feed
    rss = SimpleRSS.parse(open(url))
    new_items = 0
    all_feed_items = feed_items.to_a
    rss.items.each do |item|
      existing_item = all_feed_items.index do |existing_item|
        existing_item.guid == item.guid || existing_item.feed_link == item.feed_link
      end
      if existing_item.nil?
        FeedItem.create({
          feed_id: self.id,
          feed_link: item.link,
          feed_title: item.title,
          content: item.content_encoded,
          publication_date: item.pubDate,
          guid: item.guid
        })
        new_items += 1
      end
    end
    new_items
  end
  
  def number_unread
    count = 0
    feed_items.each do |item|
      if !item.is_read?
        count += 1
      end
    end
    count.to_s
  end
end
