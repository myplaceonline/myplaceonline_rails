class AdminSendEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info{"Started AdminSendEmailJob"}
    email = args[0]
    User.all.each do |user|
      email.process_single_target(user.email)
    end
    
    Rails.logger.info{"Ended AdminSendEmailJob"}
  end
end
