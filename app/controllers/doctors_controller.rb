class DoctorsController < MyplaceonlineController
  protected
    def sorts
      ["doctors.updated_at DESC"]
    end

    def obj_params
      params.require(:doctor).permit(
        :doctor_type,
        Myp.select_or_create_permit(params[:doctor], :contact_attributes, ContactsController.param_names)
      )
    end
end
