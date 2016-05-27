class TripStory < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip

  belongs_to :story
  accepts_nested_attributes_for :story, reject_if: proc { |attributes| StoriesController.reject_if_blank(attributes) }
  allow_existing :story
end
