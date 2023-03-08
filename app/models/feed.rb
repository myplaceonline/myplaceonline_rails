require 'rest-client'
require 'open-uri'
require 'open_uri_redirections'
require 'rss'
require 'awesome_print'

#
# Get status of feed reloads per identity:
# SELECT identity_id, items_total - items_complete - items_error AS remaining, round(((1.0 * items_complete + items_error) / items_total) * 100.0, 2) AS progress, now() at time zone 'utc', * FROM feed_load_statuses ORDER BY progress;
#
# SELECT fi.feed_id, f.url, count(*) AS cnt FROM feed_items fi INNER JOIN feeds f ON fi.feed_id = f.id GROUP BY fi.feed_id, f.url ORDER BY cnt DESC LIMIT 10;
#
class Feed < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers

  validates :name, presence: true
  validates :url, presence: true
  myplaceonline_validates_uniqueness_of :url
  
  child_properties(name: :feed_items, sort: "publication_date DESC")
  child_property(name: :password)
  
  def unread_feed_items
    feed_items.where("read is null")
  end

  def display
    name
  end
  
  def load_feed
    new_items = 0
    
    new_feed_items = []
    
    if !self.disabled?
      Rails.logger.debug{"Loading feed for #{self.id}"}
      
      response = Myp.http_get(url: url, basic_auth_password: self.password)
      
      #Rails.logger.debug{"Feed response:\n#{response}"}
      
      # https://ruby-doc.org/stdlib-2.6.3/libdoc/rss/rdoc/RSS.html
      rss = RSS::Parser.parse(response[:body], validate: false)
      
      #rss = SimpleRSS.parse(response[:body])
      
      all_feed_items = feed_items.to_a
      
      if rss.respond_to?("items") && rss.items.count > 0
        ApplicationRecord.transaction do
          rss.items.each do |item|
            #Rails.logger.debug{"Processing RSS item #{ap(item)}"}
            
            parsedxml = nil
            
            title = nil
            if title.blank? && item.respond_to?("title")
              if item.title.respond_to?("content")
                title = sanitize(item.title.content)
              else
                title = sanitize(item.title)
              end
              if title.blank?
                title = ""
              end
              title = title.strip
            end
            
            feed_link = nil
            if feed_link.blank? && item.respond_to?("enclosure") && !item.enclosure.nil?
              feed_link = item.enclosure.url
            end
            if feed_link.blank? && item.respond_to?("link")
              if item.link.respond_to?("href")
                
                # If there is more than one link, pick the alternate first
                if parsedxml.nil?
                  parsedxml = Nokogiri::XML(item.to_s)
                end
                
                alternate_link = parsedxml.root.xpath("/entry/link[@rel='alternate']")
                if alternate_link.length == 1
                  feed_link = alternate_link[0]["href"]
                else
                  feed_link = item.link.href
                end
              else
                feed_link = item.link
              end
            end
            if feed_link.blank? && item.respond_to?("feed_link")
              feed_link = item.feed_link
            end
            if feed_link.blank? && item.respond_to?("enclosure") & !item.guid.nil?
              if !URI.regexp.match(item.guid.content).nil?
                feed_link = item.guid.content
              end
            end
            
            date = nil
            if date.blank? && item.respond_to?("published")
              if item.published.respond_to?("content")
                date = item.published.content
              else
                date = item.published
              end
            end
            if date.blank? && item.respond_to?("pubDate")
              date = item.pubDate
            end
            if date.blank? && item.respond_to?("dc_date")
              date = item.dc_date
            end
            if date.blank? && item.respond_to?("updated")
              if item.updated.respond_to?("content")
                date = item.updated.content
              else
                date = item.updated
              end
            end
            if date.blank? && item.respond_to?("modified")
              date = item.modified
            end
            if date.blank? && item.respond_to?("expirationDate")
              date = item.expirationDate
            end
            
            guid = nil
            if guid.blank? && item.respond_to?("guid") && !item.guid.nil?
              guid = item.guid.content
            end
            if guid.blank? && item.respond_to?("id")
              if item.id.respond_to?("content")
                guid = item.id.content
              else
                guid = item.id
              end
            end
            if guid.blank? && !feed_link.nil?
              guid = feed_link
            end
            if guid.blank? && !date.nil?
              guid = date.to_s
            end

            content = nil
            if content.blank? && item.respond_to?("content_encoded")
              content = item.content_encoded
            end
            if content.blank? && item.respond_to?("content")
              if item.content.respond_to?("content")
                content = item.content.content
              else
                content = item.content
              end
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
                feed_title: title,
                content: content,
                publication_date: date,
                guid: guid,
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
              
              markdown = new_feed_items.reverse.map{|x| "[#{x.display}](#{LinkCreator.url("feed_feed_item_read_and_redirect", x.feed, x)}) @ #{x.publication_date}" }.join("\n\n")
              
              markdown = "#{markdown}\n\n- - -\n\n#{I18n.t("myplaceonline.category.feeds").singularize}: [#{LinkCreator.url("feed", self)}](#{LinkCreator.url("feed", self)})\n\n#{I18n.t("myplaceonline.feeds.raw_feed").singularize}: [#{url}](#{url})"
              
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
  
  def self.load_all(all_count, destroy_status_on_complete: false)
    
    user = User.current_user
    identity = User.current_user.current_identity
    
    status = FeedLoadStatus.where(identity_id: identity.id).first
    
    Rails.logger.info("Feed.refresh_all_feeds identity #{identity}, user: #{user}, status: #{status.inspect}, now: #{Time.now.utc}, diff: #{Time.now.utc - 1.day}")
    
    do_reload = status.nil?
    if !do_reload
      
      # If the status is more than a day old, there was probably an error
      if Time.now.utc - 1.day >= status.updated_at
        do_reload = true
        FeedLoadStatus.where(identity_id: identity.id).destroy_all
        Myp.warn("Found old feed load status for identity #{identity.id}")
      end
    end
    if do_reload
      FeedLoadStatus.create!(
        identity_id: identity.id,
        items_complete: 0,
        items_total: all_count,
        items_error: 0
      )
      ApplicationJob.perform(LoadRssFeedsJob, user, destroy_status_on_complete)
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

  def self.skip_check_attributes
    ["new_notify"]
  end
  
  def self.refresh_all_feeds
    Rails.logger.info("Feed.refresh_all_feeds start")
    
    if Rails.env.production? || ENV["CRONTAB_RSS"] == "true"
      User.all.each do |user|
        user.identities.each do |identity|
          
          feeds_count = Feed.where(identity_id: identity.id).count
          
          if feeds_count > 0
            MyplaceonlineExecutionContext.do_full_context(user, identity) do
              begin
                Rails.logger.info("Feed.refresh_all_feeds refreshing identity #{identity.id}")
                Feed.load_all(feeds_count, destroy_status_on_complete: true)
              rescue => e
                Myp.warn("Failed to refresh feeds for #{identity.id}: #{Myp.error_details(e)}", e)
              end
            end
          end
        end
      end
    end

    Rails.logger.info("Feed.refresh_all_feeds end")
  end
end
