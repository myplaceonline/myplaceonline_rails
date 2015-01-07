class ApartmentsController < MyplaceonlineController
  def model
    Apartment
  end

  def display_obj(obj)
    "Test"
  end

  protected
    def sorts
      ["apartments.updated_at DESC"]
    end
    
    def new_build
      @obj.location = Location.new
    end

    def obj_params
      params.require(:apartment).permit(location_attributes: LocationsController.location_params)
    end
end
