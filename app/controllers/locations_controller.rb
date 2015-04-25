class LocationsController < MyplaceonlineController
  def model
    Location
  end

  def display_obj(obj)
    obj.display
  end
  
  def self.param_names
    [:name, :address1, :address2, :address3, :region, :sub_region1, :sub_region2, :postal_code, :notes]
  end
  
  def self.reject_if_blank(attributes)
    attributes.delete_if {|key, value| key.to_s == "region" }.all? {|key, value| value.blank?}
  end

  protected
    def sorts
      ["lower(locations.name) ASC"]
    end

    def obj_params
      params.require(:location).permit(
        LocationsController.param_names,
        location_phones_attributes: [:id, :number, :_destroy]
      )
    end
    
    def update_presave
      check_nested_attributes(@obj, :location_phones, :location)
    end
end
