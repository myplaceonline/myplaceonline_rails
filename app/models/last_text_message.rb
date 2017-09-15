class LastTextMessage < ApplicationRecord
  belongs_to :from_identity, class_name: "Identity"
  belongs_to :to_identity, class_name: "Identity"
  
  def self.update_ltm(phone_number:, message_category:, to_identity:, from_identity:)
    phone_number = TextMessage.normalize(phone_number: phone_number)
    
    last_text_message = LastTextMessage.where(
      phone_number: phone_number,
      from_identity: from_identity,
      to_identity: to_identity,
    ).take
    
    if last_text_message.nil?
      last_text_message = LastTextMessage.new(
        phone_number: phone_number,
        from_identity: from_identity,
        to_identity: to_identity,
      )
    end
    
    # Primarily we just need to update the updated_at field to make this the most recent text message, but we also
    # update some other metadata fields that might be passed through in a proxied response text mesage.
    last_text_message.category = message_category
    if !to_identity.nil?
      last_text_message.to_display = LastTextMessage.target_display(identity: to_identity)
    end
    if !from_identity.nil?
      last_text_message.from_display = LastTextMessage.target_display(identity: from_identity)
    end
    last_text_message.save!
  end
  
  def self.target_display(identity:)
    result = identity.display_short
    i = result.index(" ")
    if !i.nil?
      result = result[0..i-1]
    end
    result
  end
end
