class Passport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :region, presence: true
  validates :passport_number, presence: true
  
  def display
    region + " (" + passport_number + ")"
  end
  
  child_pictures
end
