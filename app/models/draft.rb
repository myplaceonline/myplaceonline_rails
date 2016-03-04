class Draft < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :draft_name, presence: true
  
  def display
    draft_name
  end
end
