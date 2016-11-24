require 'open-uri'
require 'open_uri_redirections'

class Feed < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :url, presence: true
  
  has_many :feed_items, -> { order('publication_date DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :feed_items, allow_destroy: true, reject_if: :all_blank
  
  def unread_feed_items
    feed_items.where("read is null")
  end

  def display
    name
  end
  
  def load_feed
    rss = SimpleRSS.parse(open(url, :allow_redirections => :safe))
    new_items = 0
    all_feed_items = feed_items.to_a
    ActiveRecord::Base.transaction do
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
      if new_items > 0
        ActiveRecord::Base.connection.update_sql(
          "update feeds set total_items = total_items + #{new_items}, unread_items = unread_items + #{new_items} where id = #{self.id}"
        )
      end
    end
    new_items
  end
  
  def reset_counts
    total_items = 0
    unread_items = 0
    feed_items.each do |item|
      total_items += 1
      if !item.is_read?
        unread_items += 1
      end
    end
    ActiveRecord::Base.connection.update_sql(
      "update feeds set total_items = #{total_items}, unread_items = #{unread_items} where id = #{self.id}"
    )
  end
  
  def number_unread
    self.unread_items
  end
  
  def self.load_all(all_count)
    status = FeedLoadStatus.where(identity_id: User.current_user.primary_identity_id).first
    if status.nil?
      FeedLoadStatus.create(
        identity_id: User.current_user.primary_identity_id,
        items_complete: 0,
        items_total: all_count,
        items_error: 0
      )
      LoadRssFeedsJob.perform_later(User.current_user)
    end
  end
  
  def self.status_message
    result = nil
    status = FeedLoadStatus.where(identity_id: User.current_user.primary_identity_id).first
    if !status.nil?
      if status.finished?
        result = I18n.t("myplaceonline.feeds.loading_all_finished", complete: status.items_complete, errors: status.items_error)
        status.destroy!
      else
        result = I18n.t("myplaceonline.feeds.loading_all_inprogress", complete: status.items_progressed, total: status.items_total, percent: ((status.items_progressed.to_f / status.items_total.to_f) * 100.0).round(2))
      end
    end
    result
  end
  
  def mark_all_read
    ActiveRecord::Base.transaction do
      FeedItem.where(
        identity_id: User.current_user.primary_identity_id,
        feed_id: self.id
      ).update_all(
        read: Time.now
      )
      self.update_column(:unread_items, 0)
    end
  end
  
  def self.load_feed_from_string(str)
    SimpleRSS.parse(str.gsub("<rss:", "<").gsub("</rss:", "</"))
  end
end
