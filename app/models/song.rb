class Song < MyplaceonlineActiveRecord
  validates :song_name, presence: true
  
  def display
    song_name
  end
end
