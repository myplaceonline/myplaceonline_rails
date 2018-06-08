class LoadRssFeedsJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)
      
      # Use the urgent strategy because the atomic strategy would keep the feed objects in memory which might blow RAM
      Chewy.strategy(:urgent) do

        user = args[0]
        
        Rails.logger.info{"Started LoadRssFeedsJob user: #{user.id}"}

        executed = Myp.try_with_database_advisory_lock(Myp::DB_LOCK_LOAD_RSS_FEEDS, user.id) do
          user.identities.each do |identity|
            MyplaceonlineExecutionContext.do_full_context(user, identity) do
              
              status = FeedLoadStatus.where(identity_id: user.current_identity_id).first
              
              if !status.nil?
                status.items_complete = 0
                status.items_error = 0
                
                ApplicationRecord.transaction(requires_new: true) do
                  status.save!
                end
                
                count = 0
                feeds = Feed.where(identity_id: user.current_identity_id)
                
                feeds.each do |feed|
                  
                  count += 1
                  
                  # We load a separate Feed object because otherwise we might put
                  # too much into memory
                  temp_feed = Feed.find(feed.id)
                  
                  Rails.logger.info{"Loading #{feed.inspect}, count: #{count}, total: #{feeds.length}"}
                  
                  begin
                    
                    if temp_feed.password.nil? || !temp_feed.password.password_encrypted?
                      new_items = temp_feed.load_feed
                    else
                      # Encrypted password so we can't use it
                      Myp.warn("Feed #{feed.id} password can't be decrypted")
                    end
                    
                    Rails.logger.info{"Loaded items: #{new_items}"}
                    
                    status.items_complete += 1
                  rescue Exception => e
                    Rails.logger.info{"Error loading feed: #{Myp.error_details(e)}"}
                    status.items_error += 1
                  end
                  
                  ApplicationRecord.transaction(requires_new: true) do
                    status.save!
                  end
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
end
