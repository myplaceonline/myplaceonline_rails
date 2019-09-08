class HospitalsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:map]

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
      link: hospitals_map_path,
      icon: "navigation"
    }
    
    result
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:hospital).permit(
        :notes,
        location_attributes: LocationsController.param_names,
        health_insurance_attributes: HealthInsurancesController.param_names,
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
      "INNER JOIN locations ON locations.id = hospitals.location_id"
    end

    def all_includes
      :location
    end
end
