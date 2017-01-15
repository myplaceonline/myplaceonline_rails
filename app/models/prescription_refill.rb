class PrescriptionRefill < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :prescription
  
  validates :refill_date, presence: true
  
  belongs_to :location, :autosave => true
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

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
