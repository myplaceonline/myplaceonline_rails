class BanksController < MyplaceonlineController
  
  def model
    Bank
  end

  def display_obj(obj)
    obj.location.name
  end

  protected
    def sorts
      ["banks.updated_at DESC"]
    end
    
    def new_build
      @obj.location = Location.new
      @obj.password = Password.new
    end

    def obj_params
      params.require(:bank).permit(
        location_attributes: LocationsController.param_names.push(:id),
        password_attributes: PasswordsController.param_names.push(:id)
      )
    end
    
    def create_presave
      @obj.location.identity = current_user.primary_identity
      @obj.password.identity = current_user.primary_identity
    end
    
    def presave
      set_from_existing(:location_selection, Location, :location)
      set_from_existing(:password_selection, Password, :password)
    end
end
