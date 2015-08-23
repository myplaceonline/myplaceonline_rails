class RecreationalVehicleLoan < MyplaceonlineIdentityRecord
  belongs_to :recreational_vehicle

  belongs_to :loan, :dependent => :destroy
  accepts_nested_attributes_for :loan, allow_destroy: true, reject_if: :all_blank
end
