class Vaccine < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :vaccine_name, presence: true
  
  def display
    vaccine_name
  end

  child_properties(name: :vaccine_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(vaccine_files, [I18n.t("myplaceonline.category.vaccines"), display])
  end
end
