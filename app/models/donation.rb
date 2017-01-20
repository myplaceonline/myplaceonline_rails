class Donation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :donation_name, presence: true
  
  child_property(name: :location)

  def display
    donation_name
  end

  child_files
end
