class Bill < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :bill_name, presence: true
  
  def display
    bill_name
  end

  child_files
end
