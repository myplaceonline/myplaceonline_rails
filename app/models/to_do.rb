class ToDo < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :short_description, presence: true
  
  def display
    short_description
  end
end
