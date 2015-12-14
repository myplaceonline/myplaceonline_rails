class PlaylistShareContact < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :playlist_share

  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: :all_blank
  allow_existing :contact
end
