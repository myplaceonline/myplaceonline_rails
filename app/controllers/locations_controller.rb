class LocationsController < MyplaceonlineController
  def model
    Location
  end

  def display_obj(obj)
    obj.display
  end
  
  def self.location_params
    [:name, :address1, :address2, :address3, :region, :sub_region1, :sub_region2, :postal_code]
  end

  protected
    def sorts
      ["lower(locations.name) ASC"]
    end

    def obj_params
      params[:location][:sub_region1] = params[:sub_region1]
      params.require(:location).permit(LocationsController.location_params)
    end
end
