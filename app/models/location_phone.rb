class LocationPhone < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :location
end
