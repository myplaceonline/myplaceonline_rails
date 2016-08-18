class EmailPersonalization < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :email
  
  attr_accessor :contact

  def final_search_result
    email
  end
end
