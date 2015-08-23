class VehicleWarranty < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :vehicle

  belongs_to :warranty
  accepts_nested_attributes_for :warranty, allow_destroy: true, reject_if: :all_blank
  allow_existing :warranty
end
