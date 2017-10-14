class BeachesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:map]

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.maps.map"),
        link: beaches_map_path,
        icon: "navigation"
      }
    ]
  end
  
  def map
    @locations = self.all.map{ |x|
      if x.location.ensure_gps
        label = nil
        if x.location.estimate_driving_time && x.location.time_from_home < 86400
          label = (x.location.time_from_home/60.0).ceil.to_s
        end
        MapLocation.new(
          latitude: x.location.latitude,
          longitude: x.location.longitude,
          label: label,
          tooltip: x.display,
          popupHtml: ActionController::Base.helpers.link_to(x.display, x.location.map_url, target: "_blank")
        )
      else
        nil
      end
    }.compact
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:beach).permit(
        :crowded,
        :notes,
        location_attributes: LocationsController.param_names,
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
      "INNER JOIN locations ON locations.id = beaches.location_id"
    end

    def all_includes
      :location
    end
end
