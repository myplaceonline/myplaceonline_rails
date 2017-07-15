require 'rest-client'
require 'open-uri'
require 'open_uri_redirections'

class Feed < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :url, presence: true
  myplaceonline_validates_uniqueness_of :url
  
  child_properties(name: :feed_items, sort: "publication_date DESC")
  
  def unread_feed_items
    feed_items.where("read is null")
  end

  def display
    name
  end
  
  def load_feed
    Rails.logger.debug{"Loading feed for #{self.id}"}
    response = Myp.http_get(url: url)
    Rails.logger.debug{"Feed response:\n#{response}"}
    rss = SimpleRSS.parse(response[:body])
    new_items = 0
    new_feed_items = []
    all_feed_items = feed_items.to_a
    ApplicationRecord.transaction do
      rss.items.each do |item|
        Rails.logger.debug{"Processing #{item.inspect}"}
        
        feed_link = item.link
        if feed_link.blank?
          feed_link = item.feed_link
        end
        if feed_link.blank?
          if !URI.regexp.match(item.guid).nil?
            feed_link = item.guid
          end
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
          new_feed_item = FeedItem.create!({
            feed_id: self.id,
            feed_link: feed_link,
            feed_title: item.title,
            content: item.content_encoded,
            publication_date: date,
            guid: guid
          })
          new_feed_items << new_feed_item
          new_items += 1
        #elsif existing_item.publication_date.blank? && !date.blank?
          #Rails.logger.debug{"Updating publication date to #{date}"}
          #existing_item.update_column(:publication_date, date)
        end
      end
      
      if self.unread_items.nil?
        total_count = FeedItem.where(feed_id: self.id).count
        total_unread_count = FeedItem.where(feed_id: self.id, read: nil).count
        ApplicationRecord.connection.update(
          "update feeds set total_items = #{total_count}, unread_items = #{total_unread_count} where id = #{self.id}"
        )
      elsif new_items > 0
        ApplicationRecord.connection.update(
          "update feeds set total_items = total_items + #{new_items}, unread_items = unread_items + #{new_items} where id = #{self.id}"
        )
        
        if self.new_notify
          markdown = new_feed_items.map{|x| "[#{x.full_feed_link}](#{x.full_feed_link})" }.join("\n\n")
          body = Myp.markdown_to_html(markdown)
          body_plain = Myp.markdown_for_plain_email(markdown)
          User.current_user.current_identity.send_email(
            I18n.t("myplaceonline.feeds.notify_new_items_subject", name: self.display),
            body,
            nil,
            nil,
            body_plain
          )
        end
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
    ApplicationRecord.connection.update(
      "update feeds set total_items = #{total_items}, unread_items = #{unread_items} where id = #{self.id}"
    )
  end
  
  def number_unread
    self.unread_items
  end
  
  def self.load_all(all_count)
    status = FeedLoadStatus.where(identity_id: User.current_user.current_identity_id).first
    do_reload = status.nil?
    if !do_reload
      # If the status is more than 30 minutes old, there was probably an error
      if Time.now - 30.minutes >= status.updated_at
        do_reload = true
        FeedLoadStatus.where(identity_id: User.current_user.current_identity_id).destroy_all
        Myp.warn("Found old feed load status for identity #{User.current_user.current_identity_id}")
      end
    end
    if do_reload
      FeedLoadStatus.create!(
        identity_id: User.current_user.current_identity_id,
        items_complete: 0,
        items_total: all_count,
        items_error: 0
      )
      ApplicationJob.perform(LoadRssFeedsJob, User.current_user)
    end
  end
  
  def self.status_message
    result = nil
    status = FeedLoadStatus.where(identity_id: User.current_user.current_identity_id).first
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
    ApplicationRecord.transaction do
      FeedItem.where(
        identity_id: User.current_user.current_identity_id,
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
