class Share < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :token, presence: true
  
  def display
    token
  end
end
