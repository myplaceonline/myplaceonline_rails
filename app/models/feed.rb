require 'rest-client'
require 'open-uri'
require 'open_uri_redirections'

class Feed < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :url, presence: true
  myplaceonline_validates_uniqueness_of :url
  
  has_many :feed_items, -> { order("publication_date DESC") }, :dependent => :destroy
  accepts_nested_attributes_for :feed_items, allow_destroy: true, reject_if: :all_blank
  
  def unread_feed_items
    feed_items.where("read is null")
  end

  def display
    name
  end
  
  def load_feed
    response = Myp.http_get(url: url)
    rss = SimpleRSS.parse(response[:body])
    new_items = 0
    all_feed_items = feed_items.to_a
    ActiveRecord::Base.transaction do
      rss.items.each do |item|
        #Rails.logger.debug{"Processing #{item.inspect}"}
        
        feed_link = item.link
        if feed_link.blank?
          feed_link = item.feed_link
        end
          
        date = item.pubDate
        if date.blank?
          date = item.published
        end
        if date.blank?
          date = item.dc_date
        end
        if date.blank?
          date = item.updated
        end
        if date.blank?
          date = item.modified
        end
        if date.blank?
          date = item.expirationDate
        end
        
        guid = item.guid
        if guid.blank?
          guid = item.id
        end

        existing_item = all_feed_items.index do |existing_item|
          (!existing_item.guid.blank? && existing_item.guid == guid) ||
              (!existing_item.feed_link.blank? && existing_item.feed_link == feed_link)
        end
        
        #if !existing_item.nil?
        #  existing_item = all_feed_items[existing_item]
        #end
        
        #Rails.logger.debug{"existing_item: #{existing_item.inspect}"}
        
        if existing_item.nil?
          FeedItem.create({
            feed_id: self.id,
            feed_link: feed_link,
            feed_title: item.title,
            content: item.content_encoded,
            publication_date: date,
            guid: guid
          })
          new_items += 1
        #elsif existing_item.publication_date.blank? && !date.blank?
          #Rails.logger.debug{"Updating publication date to #{date}"}
          #existing_item.update_column(:publication_date, date)
        end
      end
      if new_items > 0
        ActiveRecord::Base.connection.update(
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
    ActiveRecord::Base.connection.update(
      "update feeds set total_items = #{total_items}, unread_items = #{unread_items} where id = #{self.id}"
    )
  end
  
  def number_unread
    self.unread_items
  end
  
  def self.load_all(all_count)
    status = FeedLoadStatus.where(identity_id: User.current_user.primary_identity_id).first
    do_reload = status.nil?
    if !do_reload
      # If the status is more than 30 minutes old, there was probably an error
      if Time.now - 30.minutes >= status.updated_at
        do_reload = true
        Myp.warn("Found old feed load status for identity #{User.current_user.primary_identity_id}")
      end
    end
    if do_reload
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
