class PrescriptionRefill < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :prescription
  
  validates :refill_date, presence: true
  
  child_property(name: :location)

  def display
    Myp.appendstrwrap(prescription.display, Myp.display_date_short_year(self.refill_date, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :refill_date,
      :notes,
      location_attributes: LocationsController.param_names,
    ]
  end
end
