class Museum < ApplicationRecord
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
  
  child_property(name: :location, required: true)
  
  child_property(name: :website)
  
  def display
    location.display
  end
end
