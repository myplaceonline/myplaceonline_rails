class Share < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :token, presence: true
  
  def display
    token
  end
  
  def self.build_share(owner_identity:)
    result = Share.new
    result.identity = owner_identity
    result.token = SecureRandom.hex(22)
    result
  end
end
