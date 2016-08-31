class EmailToken < ActiveRecord::Base
  belongs_to :identity
  
  def self.find_or_create_token_by_email(email, identity: nil)
    et = EmailToken.where(email: email).first
    if et.nil?
      et = EmailToken.new
      et.token = SecureRandom.hex(10)
      et.identity = identity
      et.email = email
      et.save!
    end
    et
  end

  def self.find_or_create_by_email(email, identity: nil)
    self.find_or_create_token_by_email(email, identity: identity).token
  end
end
