class Surgery < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :surgery_name, presence: true
  
  def display
    surgery_name
  end
  
  child_property(name: :hospital, model: Location)
  
  child_property(name: :doctor)
  
  child_files
end
