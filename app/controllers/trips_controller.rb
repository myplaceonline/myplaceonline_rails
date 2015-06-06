class TripsController < MyplaceonlineController
  def model
    Trip
  end

  def display_obj(obj)
    obj.display
  end

  def may_upload
    true
  end
  
  protected
    def sorts
      ["trips.started DESC"]
    end

    def obj_params
      params.require(:trip).permit(
        :started,
        :ended,
        :notes,
        :work,
        select_or_create_permit(:trip, :location_attributes, LocationsController.param_names),
        trip_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
