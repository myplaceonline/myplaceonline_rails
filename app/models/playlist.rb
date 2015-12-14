class Playlist < MyplaceonlineIdentityRecord
  validates :playlist_name, presence: true
  
  has_many :playlist_songs, :dependent => :destroy
  accepts_nested_attributes_for :playlist_songs, allow_destroy: true, reject_if: :all_blank
  
  has_many :playlist_shares

  def display
    playlist_name
  end
end
