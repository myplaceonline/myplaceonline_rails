class MusicAlbumFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :music_album)
end
