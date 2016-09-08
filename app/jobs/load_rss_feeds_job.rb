class LoadRssFeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started LoadRssFeedsJob"}

    user = args[0]

    got_lock = false
    begin
      ExecutionContext.push
      got_lock = Myp.database_advisory_lock(Myp::DB_LOCK_LOAD_RSS_FEEDS, user.id)
      if got_lock
        User.current_user = user
        
        status = FeedLoadStatus.where(identity_id: user.primary_identity_id).first
        status.items_complete = 0
        status.items_error = 0
        
        if !status.nil?
          Feed.where(identity_id: user.primary_identity_id).each do |feed|
            
            # We load a separate Feed object because otherwise we might put
            # too much into memory
            temp_feed = Feed.find(feed.id)
            
            Rails.logger.info{"Loading #{feed.inspect}"}
            
            begin
              temp_feed.load_feed
              status.items_complete += 1
            rescue Exception => e
              status.items_error += 1
            end
            
            status.save!
          end
        end
      else
        Rails.logger.info("ensure_pending failed lock")
      end
    ensure
      ExecutionContext.clear
      if got_lock
        Myp.database_advisory_unlock(Myp::DB_LOCK_LOAD_RSS_FEEDS, user.id)
      end
    end
    Rails.logger.debug{"Finished LoadRssFeedsJob"}
  end
end
