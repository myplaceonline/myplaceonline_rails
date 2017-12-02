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

  def self.param_names
    [
      :id,
      :_delete,
      :notes,
      :rating,
      location_attributes: LocationsController.param_names,
      end_location_attributes: LocationsController.param_names,
      parking_location_attributes: LocationsController.param_names,
      trek_pictures_attributes: FilesController.multi_param_names,
    ]
  end
end
