class HotelsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["hotels.updated_at DESC"]
    end

    def obj_params
      params.require(:hotel).permit(
        :notes,
        :overall_rating,
        :breakfast_rating,
        location_attributes: LocationsController.param_names
      )
    end
end
