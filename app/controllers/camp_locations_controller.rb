class CampLocationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def obj_params
      params.require(:camp_location).permit(
        :notes,
        :rating,
        :vehicle_parking,
        :free,
        :sewage,
        :fresh_water,
        :electricity,
        :internet,
        :trash,
        :shower,
        :bathroom,
        :noise_level,
        :overnight_allowed,
        :boondocking,
        :cell_phone_reception,
        :cell_phone_data,
        location_attributes: LocationsController.param_names,
        membership_attributes: MembershipsController.param_names
      )
    end

    def sorts
      [%{
       CASE
        WHEN locations.name IS NOT NULL THEN locations.name
        WHEN locations.address1 IS NOT NULL THEN locations.address1
        WHEN locations.address2 IS NOT NULL THEN locations.address2
        WHEN locations.address3 IS NOT NULL THEN locations.address3
        WHEN locations.sub_region2 IS NOT NULL THEN locations.sub_region2
        WHEN locations.sub_region1 IS NOT NULL THEN locations.sub_region1
        ELSE locations.region
       END ASC
      }]
    end
    
    def all_joins
      "INNER JOIN locations ON locations.id = camp_locations.location_id"
    end

    def all_includes
      :location
    end
end
