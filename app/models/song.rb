class Song < MyplaceonlineIdentityRecord
  validates :song_name, presence: true
  
  belongs_to :identity_file
  accepts_nested_attributes_for :identity_file, reject_if: :all_blank

  def display
    song_name
  end

  before_validation :update_file_folder
    
  def update_file_folder
    if !identity_file.nil? && identity_file.folder.nil?
      # TODO add artist folder
      identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.songs")])
    end
  end
end
