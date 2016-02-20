class TripsController < MyplaceonlineController
  def may_upload
    true
  end
  
  protected
    def sorts
      ["trips.started DESC"]
    end

    def insecure
      true
    end
    
    def obj_params
      params.require(:trip).permit(
        :started,
        :ended,
        :notes,
        :work,
        location_attributes: LocationsController.param_names,
        trip_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ],
        hotel_attributes: HotelsController.param_names
      )
    end
end
