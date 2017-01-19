class Trek < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    location.display
  end

  after_commit :update_file_folders, on: [:create, :update]
    
  def update_file_folders
    put_files_in_folder(trek_pictures, [I18n.t("myplaceonline.category.treks"), display])
  end

  child_properties(name: :trek_pictures)
end
