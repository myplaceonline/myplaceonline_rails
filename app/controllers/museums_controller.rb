class MuseumsController < MyplaceonlineController
  protected
    def sorts
      ["museums.updated_at DESC"]
    end

    def obj_params
      params.require(:museum).permit(
        :museum_id,
        :museum_type,
        :notes,
        Myp.select_or_create_permit(params[:museum], :location_attributes, LocationsController.param_names)
      )
    end
end
