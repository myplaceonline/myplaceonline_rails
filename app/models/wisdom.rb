class Wisdom < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :name, presence: true
  
  def display
    name
  end

  child_properties(name: :wisdom_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(wisdom_files, [I18n.t("myplaceonline.category.wisdoms"), display])
  end
end
