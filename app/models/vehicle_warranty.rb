class VehicleWarranty < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle

  child_property(name: :warranty)
end
