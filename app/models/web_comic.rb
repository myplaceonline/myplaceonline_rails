class WebComic < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website
  accepts_nested_attributes_for :website, reject_if: proc { |attributes| WebsitesController.reject_if_blank(attributes) }
  allow_existing :website
  
  validates :website, presence: true

  belongs_to :feed
  accepts_nested_attributes_for :feed, reject_if: proc { |attributes| FeedsController.reject_if_blank(attributes) }
  allow_existing :feed
  
  def display
    web_comic_name
  end
end
