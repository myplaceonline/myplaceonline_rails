class Trek < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)

  child_property(name: :end_location, model: Location)
  
  child_property(name: :parking_location, model: Location)
  
  def display
    location.display
  end

  child_pictures
end
