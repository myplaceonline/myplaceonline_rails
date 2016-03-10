class CafesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["cafes.updated_at DESC"]
    end

    def obj_params
      params.require(:cafe).permit(
        :notes,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end
end
