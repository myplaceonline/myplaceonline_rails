class BanksController < MyplaceonlineController
  
  def model
    Bank
  end

  def display_obj(obj)
    obj.location.name
  end
  
  def self.param_names
    []
  end

  def self.reject_if_blank(attributes)
    attributes.all? {|key, value| value.blank?}
  end

  protected
    def sorts
      ["banks.updated_at DESC"]
    end
    
    def obj_params
      params.require(:bank).permit(
        select_or_create_permit(:bank, :location_attributes, LocationsController.param_names),
        select_or_create_permit(:bank, :password_attributes, PasswordsController.param_names)
      )
    end
    
    def create_presave
      @obj.location.identity = current_user.primary_identity
      if !@obj.password.nil?
        @obj.password.identity = current_user.primary_identity
      end
    end
end
