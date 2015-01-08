class ApartmentsController < MyplaceonlineController
  
  def model
    Apartment
  end

  def display_obj(obj)
    obj.location.name
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
    
    def create_presave
      #@obj.location.identity = current_user.primary_identity
    end
    
    def presave
      if !params[:location_selection].blank?
        id = params[:location_selection]
        i = id.rindex('/')
        if !i.nil?
          id = id[i+1..-1].to_i
          location = Location.find(id)
          authorize! :manage, location
          @obj.location = location
        end
      end
    end
end
