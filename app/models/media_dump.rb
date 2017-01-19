class MediaDump < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :media_dump_name, presence: true

  child_properties(name: :media_dump_files, sort: "position ASC, updated_at ASC")
  
  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(media_dump_files, [I18n.t("myplaceonline.category.media_dumps"), display])
  end
  
  def display
    media_dump_name
  end
end
