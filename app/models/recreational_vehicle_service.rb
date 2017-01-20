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

  child_files

  def file_folders_parent
    :recreational_vehicle
  end
end
