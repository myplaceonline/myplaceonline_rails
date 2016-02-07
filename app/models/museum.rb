class Museum < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  MUSEUM_TYPES = [
    ["myplaceonline.museum_types.art", 0],
    ["myplaceonline.museum_types.bot", 1],
    ["myplaceonline.museum_types.cmu", 2],
    ["myplaceonline.museum_types.gmu", 3],
    ["myplaceonline.museum_types.hsc", 4],
    ["myplaceonline.museum_types.hst", 5],
    ["myplaceonline.museum_types.nat", 6],
    ["myplaceonline.museum_types.sci", 7],
    ["myplaceonline.museum_types.zaw", 8],
  ]
  
  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  belongs_to :website
  accepts_nested_attributes_for :website, reject_if: proc { |attributes| WebsitesController.reject_if_blank(attributes) }
  allow_existing :website
  
  def display
    location.display
  end
end
