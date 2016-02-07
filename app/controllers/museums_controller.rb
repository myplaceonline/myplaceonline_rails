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
        location_attributes: LocationsController.param_names,
        website_attributes: WebsitesController.param_names
      )
    end
end
