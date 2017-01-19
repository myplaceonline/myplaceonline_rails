class CompleteDueItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar
  
  def display
    nil
  end
  
  def final_search_result
    calendar
  end
end
