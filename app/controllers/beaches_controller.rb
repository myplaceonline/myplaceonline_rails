class BeachesController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def simple_index_filters
    [
      { name: :fires_allowed },
      { name: :fires_disallowed },
      { name: :free },
      { name: :paid },
      { name: :tents_allowed },
      { name: :tents_disallowed },
      { name: :canopies_allowed },
      { name: :canopies_disallowed },
    ]
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:beach).permit(
        :crowded,
        :notes,
        :rating,
        :fires_allowed,
        :fires_disallowed,
        :free,
        :paid,
        :tents_allowed,
        :tents_disallowed,
        :canopies_allowed,
        :canopies_disallowed,
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

    def show_map?
      true
    end
end
