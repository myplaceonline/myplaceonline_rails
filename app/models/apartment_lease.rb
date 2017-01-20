class ApartmentLease < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :apartment

  def display
    apartment.display
  end

  child_files
end
