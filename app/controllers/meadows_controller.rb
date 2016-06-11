class MeadowsController < MyplaceonlineController
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
      ["meadows.updated_at DESC"]
    end

    def obj_params
      params.require(:meadow).permit(
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
