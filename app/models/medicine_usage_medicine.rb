class MedicineUsageMedicine < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :medicine_usage

  child_property(name: :medicine)
end
