class Website < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :url, presence: true
  
  def display
    title
  end
end
