class Song < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :song_name, presence: true
  
  belongs_to :identity_file
  accepts_nested_attributes_for :identity_file, reject_if: :all_blank

  belongs_to :musical_group
  accepts_nested_attributes_for :musical_group, reject_if: :all_blank
  allow_existing :musical_group

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
end
