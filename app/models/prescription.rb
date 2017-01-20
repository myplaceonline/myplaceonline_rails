class Prescription < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :prescription_name, presence: true
  
  child_property(name: :doctor)
  
  child_properties(name: :prescription_refills, sort: "refill_date DESC")

  def display
    prescription_name
  end

  child_files
end
