class RestaurantsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:random, :map]

  def index
    @not_visited = params[:not_visited]
    if !@not_visited.blank?
      @not_visited = @not_visited.to_bool
    end
    super
  end

  def random
    @search = params[:search]
    @location = params[:location]
    if request.method == "GET"
      loc = current_user.current_identity.primary_location
      if !loc.nil?
        @location = loc.location.address_one_line
      end
    end
    if !@search.blank?
      max = 19
      parameters = { term: @search, limit: max, radius_filter: 1609 } # 1609 meters ~= 1 mile
      #@result = Yelp.client.search(@location, parameters)
      #if @result.businesses.length > max
      #  max = @result.businesses.length
      #end
      @business = @result.businesses[rand(max)]
    end
  end

  def may_upload
    true
  end

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def footer_items_index
    result = super
    
    result << {
      title: I18n.t("myplaceonline.maps.map"),
      link: restaurants_map_path,
      icon: "navigation"
    }
    
    result << {
      title: I18n.t("myplaceonline.random.restaurant"),
      link: random_activity_path(:filter_restaurants => "1"),
      icon: "search"
    }

    result
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:restaurant).permit(
        :notes,
        :visited,
        :rating,
        :ethical_meat,
        location_attributes: LocationsController.param_names,
        restaurant_pictures_attributes: FilesController.multi_param_names
      )
    end

    def default_sort_columns
      [Location.sorts]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.locations.name"), default_sort_columns[0]]
      ]
    end

    def all_joins
      "INNER JOIN locations ON locations.id = restaurants.location_id"
    end

    def all_includes
      :location
    end

    def simple_index_filters
      [
        { name: :ethical_meat },
        { name: :not_visited, column: :visited, inverted: true },
      ]
    end
end
