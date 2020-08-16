class BasketballCourtsController < MyplaceonlineController
  def may_upload
    true
  end

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:basketball_court).permit(
        :notes,
        :rating,
        location_attributes: LocationsController.param_names,
        basketball_court_files_attributes: FilesController.multi_param_names,
      )
    end

    def show_map?
      true
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
      "INNER JOIN locations ON locations.id = basketball_courts.location_id"
    end

    def all_includes
      :location
    end
end
