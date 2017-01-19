class PlaylistSong < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :playlist

  child_property(name: :song)
end
