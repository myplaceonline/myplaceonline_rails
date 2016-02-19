class Podcast < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :feed, presence: true

  belongs_to :feed
  accepts_nested_attributes_for :feed, reject_if: proc { |attributes| FeedsController.reject_if_blank(attributes) }
  allow_existing :feed
  
  def display
    feed.display
  end
end
