class PlaylistSong < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :playlist

  belongs_to :song
  accepts_nested_attributes_for :song, reject_if: :all_blank
  allow_existing :song
end
