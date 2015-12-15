class Feed < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :url, presence: true
  
  def display
    name
  end
end
