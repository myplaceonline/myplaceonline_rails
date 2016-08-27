class DueItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :calendar
  
  def final_search_result
    self.calendar
  end
end
