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

  has_many :vehicle_registration_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_registration_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :vehicle_registration_files, [{:name => :identity_file}]

  before_validation :update_file_folders

  def update_file_folders
    put_files_in_folder(vehicle_registration_files, [I18n.t("myplaceonline.category.vehicle_registrations"), vehicle.display, display])
  end
end
