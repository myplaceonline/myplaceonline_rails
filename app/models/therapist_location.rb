class TherapistLocation < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :therapist

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: :all_blank
  allow_existing :location
end
