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

  child_properties(name: :vehicle_registration_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]

  def update_file_folders
    put_files_in_folder(vehicle_registration_files, [I18n.t("myplaceonline.category.vehicle_registrations"), vehicle.display, display])
  end
end
