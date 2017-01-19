class Donation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :donation_name, presence: true
  
  child_property(name: :location)

  def display
    donation_name
  end

  child_properties(name: :donation_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(donation_files, [I18n.t("myplaceonline.category.donations"), display])
  end
end
