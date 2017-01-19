class TripPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip
  
  child_property(name: :identity_file, required: true)
  
  def display
    identity_file.display
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    if !trip.nil?
      put_file_in_folder(self, trip.picture_folders)
    end
  end
end
