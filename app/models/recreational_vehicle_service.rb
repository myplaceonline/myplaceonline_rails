class RecreationalVehicleService < ActiveRecord::Base
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

  has_many :recreational_vehicle_service_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_service_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :recreational_vehicle_service_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(recreational_vehicle_service_files, [I18n.t("myplaceonline.category.recreational_vehicles"), recreational_vehicle.display, display])
  end
end
