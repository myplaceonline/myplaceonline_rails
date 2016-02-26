class TripsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def shared
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
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
        trip_pictures_attributes: FilesController.multi_param_names,
        hotel_attributes: HotelsController.param_names
      )
    end
end
