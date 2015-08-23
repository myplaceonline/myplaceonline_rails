class Song < MyplaceonlineIdentityRecord
  validates :song_name, presence: true
  
  def display
    song_name
  end
end
