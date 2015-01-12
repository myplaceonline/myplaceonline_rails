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
    
    def obj_params
      params.require(:apartment).permit(
        select_or_create_permit(:apartment, :location_attributes, LocationsController.param_names),
        select_or_create_permit(:apartment, :landlord_attributes, ContactsController.param_names),
        apartment_leases_attributes: [:id, :start_date, :end_date, :monthly_rent, :moveout_fee, :deposit, :terminate_by, :_destroy]
      )
    end
    
    def create_presave
      @obj.location.identity = current_user.primary_identity
      if !@obj.landlord.nil?
        @obj.landlord.identity = current_user.primary_identity
      end
    end
    
    def update_presave
      check_nested_attributes(@obj, :apartment_leases, :apartment)
    end
end
