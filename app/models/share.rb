class Share < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :token, presence: true
  
  def display
    token
  end
end
