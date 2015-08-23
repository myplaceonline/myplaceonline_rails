class RestaurantsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:random]

  def random
    @search = params[:search]
    @location = params[:location]
    if request.method == "GET"
      loc = current_user.primary_identity.primary_location
      if !loc.nil?
        @location = loc.location.address_one_line
      end
    end
    if !@search.blank?
      max = 19
      parameters = { term: @search, limit: max, radius_filter: 1609 } # 1609 meters ~= 1 mile
      @result = Yelp.client.search(@location, parameters)
      if @result.businesses.length > max
        max = @result.businesses.length
      end
      @business = @result.businesses[rand(max)]
    end
  end

  protected
    def sorts
      ["restaurants.updated_at DESC"]
    end

    def obj_params
      params.require(:restaurant).permit(
        :notes,
        :rating,
        Myp.select_or_create_permit(params[:restaurant], :location_attributes, LocationsController.param_names)
      )
    end
end
