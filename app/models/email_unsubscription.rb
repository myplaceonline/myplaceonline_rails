class EmailUnsubscription < ApplicationRecord
  belongs_to :identity
  
  def self.can_send?(email)
    return EmailUnsubscription.where(email: email).take.nil?
  end
end
