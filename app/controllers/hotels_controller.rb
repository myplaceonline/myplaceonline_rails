class HotelsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def self.param_names
    [
      :id,
      :notes,
      :overall_rating,
      :breakfast_rating,
      :room_number,
      :checkin_date,
      :checkout_date,
      :confirmation_number,
      :total_cost,
      location_attributes: LocationsController.param_names
    ]
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:hotel).permit(
        HotelsController.param_names
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
      "INNER JOIN locations ON locations.id = hotels.location_id"
    end

    def all_includes
      :location
    end
end
