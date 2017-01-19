class MediaDumpFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :media_dump
  
  child_property(name: :identity_file, required: true)
  
  def display
    identity_file.display
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    if !media_dump.nil?
      put_file_in_folder(self, [I18n.t("myplaceonline.category.media_dumps"), media_dump.display])
    end
  end
end
