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
      params.require(:location).permit(:name, :address1, :address2, :address3, :region, :subregion1, :subregion2)
    end
end
