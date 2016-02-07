class LocationsController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :address1,
      :address2,
      :address3,
      :region,
      :sub_region1,
      :sub_region2,
      :postal_code,
      :notes,
      :latitude,
      :longitude,
      location_phones_attributes: [:id, :number, :_destroy],
      website_attributes: WebsitesController.param_names
    ]
  end
  
  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "region" }.all?{|key, value|
      if key == "website_attributes"
        WebsitesController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  protected
    def sorts
      ["lower(locations.name) ASC"]
    end

    def obj_params
      params.require(:location).permit(
        LocationsController.param_names
      )
    end
end
