class ConcertMusicalGroup < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :concert

  belongs_to :musical_group
  accepts_nested_attributes_for :musical_group, reject_if: :all_blank
  allow_existing :musical_group
end
