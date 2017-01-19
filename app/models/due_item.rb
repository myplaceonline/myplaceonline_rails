class DueItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :calendar
  
  def final_search_result
    self.calendar
  end
end
