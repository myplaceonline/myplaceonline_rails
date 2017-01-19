class EmailPersonalization < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :email
  
  attr_accessor :contact

  def final_search_result
    email
  end

  def self.skip_check_attributes
    ["do_send"]
  end
end
