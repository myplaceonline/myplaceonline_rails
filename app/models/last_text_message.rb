class LastTextMessage < ApplicationRecord
  belongs_to :from_identity, class_name: "Identity"
  belongs_to :to_identity, class_name: "Identity"
  
  def self.update_ltm(phone_number:, message_category:, to_identity_id:, from_identity_id:)
    phone_number = TextMessage.normalize(phone_number: phone_number)
    last_text_message = LastTextMessage.where(phone_number: phone_number).take
    if last_text_message.nil?
      last_text_message = LastTextMessage.new(
        phone_number: phone_number,
      )
    end
    last_text_message.category = message_category
    last_text_message.from_identity_id = from_identity_id
    last_text_message.to_identity_id = to_identity_id
    last_text_message.save!
  end
end
