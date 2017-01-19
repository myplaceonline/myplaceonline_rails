class RecreationalVehicleService < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :recreational_vehicle
  validates :short_description, presence: true
  
  def display
    short_description
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.date_serviced = User.current_user.date_now
    result
  end

  child_properties(name: :recreational_vehicle_service_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(recreational_vehicle_service_files, [I18n.t("myplaceonline.category.recreational_vehicles"), recreational_vehicle.display, display])
  end
end
