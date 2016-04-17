class DessertLocationsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:random]

  def index
    @not_visited = params[:not_visited]
    if !@not_visited.blank?
      @not_visited = @not_visited.to_bool
    end
    super
  end

  protected
    def insecure
      true
    end

    def sorts
      ["dessert_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:dessert_location).permit(
        :notes,
        :visited,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end

    def all_additional_sql(strict)
      if @not_visited && !strict
        "and (visited is null or visited = false)"
      else
        nil
      end
    end
end
