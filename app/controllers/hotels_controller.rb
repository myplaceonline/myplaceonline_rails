class HotelsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "location_attributes"
        LocationsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  def self.param_names
    [
      :id,
      :notes,
      :overall_rating,
      :breakfast_rating,
      :room_number,
      location_attributes: LocationsController.param_names
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["hotels.updated_at DESC"]
    end

    def obj_params
      params.require(:hotel).permit(
        HotelsController.param_names
      )
    end
end
