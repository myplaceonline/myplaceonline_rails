class LocationsController < MyplaceonlineController
  def model
    Location
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(locations.name) ASC"]
    end

    def obj_params
      params[:location][:sub_region1] = params[:sub_region1]
      params.require(:location).permit(:name, :address1, :address2, :address3, :region, :sub_region1, :sub_region2)
    end
end
