class Prescription < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :prescription_name, presence: true
  
  child_property(name: :doctor)
  
  child_properties(name: :prescription_refills, sort: "refill_date DESC")

  def display
    prescription_name
  end

  child_properties(name: :prescription_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(prescription_files, [I18n.t("myplaceonline.category.prescriptions"), display])
  end
end
