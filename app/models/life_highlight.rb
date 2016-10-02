class LifeHighlight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :life_highlight_name, presence: true
  
  def display
    life_highlight_name
  end
end
