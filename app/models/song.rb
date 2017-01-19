class Song < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :song_name, presence: true
  
  child_property(name: :identity_file)

  child_property(name: :musical_group)

  def display
    if musical_group.nil?
      song_name
    else
      musical_group.display + " - " + song_name
    end
  end

  before_validation :update_file_folder
    
  def update_file_folder
    if !identity_file.nil? && identity_file.folder.nil?
      if musical_group.nil?
        identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.songs")])
      else
        identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.songs"), musical_group.display])
      end
    end
  end

  def self.skip_check_attributes
    ["secret", "awesome"]
  end
end
