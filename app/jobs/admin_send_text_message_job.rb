class AdminSendTextMessageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.info{"Started AdminSendTextMessageJob"}
      
      admin_text_message = args[0]

      Rails.logger.debug{"Email: #{admin_text_message.inspect}; #{admin_text_message.text_message.inspect}"}
      
      send_only_to = nil
      if !admin_text_message.send_only_to.blank?
        send_only_to = admin_text_message.send_only_to.split(",").map{|e| [e, true]}.to_h
      end
      
      exclude_numbers = nil
      if !admin_text_message.exclude_numbers.blank?
        exclude_numbers = admin_text_message.exclude_numbers.split(",").map{|e| [e, true]}.to_h
      end

      User.all.each do |user|
        user.primary_identity.identity_phones.each do |identity_phone|
          if identity_phone.accepts_sms?
            if send_only_to.nil? || send_only_to[identity_phone.number]
              if exclude_numbers.nil? || !exclude_numbers[identity_phone.number]
                admin_text_message.text_message.process_single_target(identity_phone.number)
              end
            end
          end
        end
      end
      
      Rails.logger.info{"Ended AdminSendTextMessageJob"}
    end
  end
end
