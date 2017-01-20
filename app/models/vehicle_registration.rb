class VehicleRegistration < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vehicle
  
  validates :registration_date, presence: true
  
  def display
    Myp.appendstrwrap(vehicle.display, Myp.display_date_short_year(self.registration_date, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :registration_date,
      :registration_source,
      vehicle_registration_files_attributes: FilesController.multi_param_names
    ]
  end

  child_files

  def file_folders_parent
    :vehicle
  end
end
