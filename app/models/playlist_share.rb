class PlaylistShare < MyplaceonlineIdentityRecord
  belongs_to :playlist

  validates :subject, presence: true

  has_many :playlist_share_contacts
  accepts_nested_attributes_for :playlist_share_contacts, allow_destroy: true, reject_if: :all_blank
  
  validate :has_contacts
  
  def has_contacts
    if playlist_share_contacts.length == 0
      errors.add(:contacts, I18n.t("myplaceonline.playlists.requires_contacts"))
    end
  end
end
