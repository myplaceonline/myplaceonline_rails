class TripStory < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip

  belongs_to :story
  accepts_nested_attributes_for :story, reject_if: :all_blank
  allow_existing :story
end
