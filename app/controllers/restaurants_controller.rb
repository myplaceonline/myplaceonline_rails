class RestaurantsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:random]

  def random
    @search = params[:search]
    @location = params[:location]
    if !@search.blank?
      max = 19
      parameters = { term: @search, limit: max, radius_filter: 1609 }
      @result = Yelp.client.search(@location, parameters)
      @business = @result.businesses[rand(max)]
    end
  end
end
