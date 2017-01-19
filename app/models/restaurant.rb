class Restaurant < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  child_property(name: :location)
  
  def display
    location.display
  end

  after_commit :update_file_folders, on: [:create, :update]
    
  def update_file_folders
    put_files_in_folder(restaurant_pictures, [I18n.t("myplaceonline.category.restaurants"), display])
  end

  child_properties(name: :restaurant_pictures)

  def self.skip_check_attributes
    ["visited"]
  end
end
