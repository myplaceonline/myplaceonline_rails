class ConcertMusicalGroup < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :concert

  child_property(name: :musical_group)
end
