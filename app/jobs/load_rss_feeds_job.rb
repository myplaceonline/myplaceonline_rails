class LoadRssFeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started LoadRssFeedsJob"}
    user = args[0]
    begin
      User.current_user = user
      
      status = FeedLoadStatus.where(identity_id: user.primary_identity_id).first
      status.items_complete = 0
      status.items_error = 0
      
      if !status.nil?
        Feed.where(identity_id: user.primary_identity_id).each do |feed|
          Rails.logger.debug{"Loading #{feed.inspect}"}
          
          begin
            feed.load_feed
            status.items_complete += 1
          rescue Exception => e
            status.items_error += 1
          end
          
          status.save!
        end
      end
    ensure
      User.current_user = nil
    end
    Rails.logger.debug{"Finished LoadRssFeedsJob"}
  end
end
