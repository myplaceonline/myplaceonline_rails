class ApartmentLease < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :apartment
end
