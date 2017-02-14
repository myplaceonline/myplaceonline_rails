class MusicAlbum < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :music_album_name, presence: true
  
  def display
    music_album_name
  end

  child_files
end
