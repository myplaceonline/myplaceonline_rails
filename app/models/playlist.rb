class Playlist < MyplaceonlineIdentityRecord
  validates :playlist_name, presence: true
  
  has_many :playlist_songs, :dependent => :destroy
  accepts_nested_attributes_for :playlist_songs, allow_destroy: true, reject_if: :all_blank
  
  def display
    playlist_name
  end
end
