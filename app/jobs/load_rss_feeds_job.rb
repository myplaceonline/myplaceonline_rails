class LoadRssFeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Use the urgent strategy because the atomic strategy would keep the feed objcts in memory which might blow RAM
    Chewy.strategy(:urgent) do
      user = args[0]
      
      Rails.logger.info{"Started LoadRssFeedsJob user: #{user.id}"}

      executed = Myp.try_with_database_advisory_lock(Myp::DB_LOCK_LOAD_RSS_FEEDS, user.id, requires_new_transaction: true) do
        ExecutionContext.stack do
          User.current_user = user
          
          status = FeedLoadStatus.where(identity_id: user.primary_identity_id).first
          
          if !status.nil?
            status.items_complete = 0
            status.items_error = 0
            
            ActiveRecord::Base.transaction(requires_new: true) do
              status.save!
            end
            
            count = 0
            feeds = Feed.where(identity_id: user.primary_identity_id)
            
            feeds.each do |feed|
              
              count += 1
              
              # We load a separate Feed object because otherwise we might put
              # too much into memory
              temp_feed = Feed.find(feed.id)
              
              Rails.logger.info{"Loading #{feed.inspect}, count: #{count}, total: #{feeds.length}"}
              
              begin
                new_items = temp_feed.load_feed
                Rails.logger.info{"Loaded items: #{new_items}"}
                
                status.items_complete += 1
              rescue Exception => e
                Rails.logger.info{"Error loading feed: #{Myp.error_details(e)}"}
                status.items_error += 1
              end
              
              ActiveRecord::Base.transaction(requires_new: true) do
                status.save!
              end
            end
          end
        end
      end
      
      if !executed
        Myp.warn("LoadRssFeedsJob could not lock (#{Myp::DB_LOCK_LOAD_RSS_FEEDS}, #{user.id})")
      end

      Rails.logger.info{"Finished LoadRssFeedsJob"}
    end
  end
end
