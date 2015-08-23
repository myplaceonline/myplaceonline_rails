class MedicineUsageMedicine < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :medicine_usage
  belongs_to :medicine
  accepts_nested_attributes_for :medicine, allow_destroy: true, reject_if: :all_blank
  allow_existing :medicine
end
