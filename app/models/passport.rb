class Passport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :region, presence: true
  validates :passport_number, presence: true
  
  def display
    region + " (" + passport_number + ")"
  end
  
  child_properties(name: :passport_pictures)

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(passport_pictures, [I18n.t("myplaceonline.category.passports"), display])
  end

end
