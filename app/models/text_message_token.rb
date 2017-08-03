class TextMessageToken < ApplicationRecord
  belongs_to :identity
  
  def self.find_or_create_token_by_phone(phone_number:, identity:)
    phone_number = TextMessage.normalize(phone_number: phone_number)
    t = TextMessageToken.where(phone_number: phone_number, identity: identity).first
    if t.nil?
      t = TextMessageToken.create!(
        phone_number: phone_number,
        token: SecureRandom.hex(10),
        identity: identity,
      )
    end
    t
  end

  def self.find_or_create_by_phone(phone_number:, identity:)
    self.find_or_create_token_by_phone(phone_number: phone_number, identity: identity).token
  end
end
