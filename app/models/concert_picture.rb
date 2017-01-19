class ConcertPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :concert

  validates :identity_file, presence: true

  child_property(name: :identity_file)
end
