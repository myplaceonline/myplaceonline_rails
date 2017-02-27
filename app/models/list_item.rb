class ListItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :list
  
  def final_search_result
    list
  end
end
