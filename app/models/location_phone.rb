class LocationPhone < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :location
end
