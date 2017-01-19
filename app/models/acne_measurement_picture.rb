class AcneMeasurementPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :acne_measurement

  child_property(name: :identity_file, required: true)
end
