class ApartmentsController < MyplaceonlineController
  
  def model
    Apartment
  end

  def may_upload
    true
  end

  protected
    def sorts
      ["apartments.updated_at DESC"]
    end
    
    def obj_params
      params.require(:apartment).permit(
        :notes,
        Myp.select_or_create_permit(params[:apartment], :location_attributes, LocationsController.param_names),
        Myp.select_or_create_permit(params[:apartment], :landlord_attributes, ContactsController.param_names),
        apartment_leases_attributes: [:id, :start_date, :end_date, :monthly_rent, :moveout_fee, :deposit, :terminate_by, :_destroy],
        apartment_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
