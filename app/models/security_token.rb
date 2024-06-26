class SecurityToken < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :security_token_value, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :security_token_value, presence: true
  
  def display
    self.security_token_value
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.security_token_value = SecureRandom.uuid
    result
  end
end
