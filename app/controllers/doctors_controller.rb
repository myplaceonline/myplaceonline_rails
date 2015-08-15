class DoctorsController < MyplaceonlineController
  def model
    Doctor
  end

  protected
    def sorts
      ["doctors.updated_at DESC"]
    end

    def obj_params
      params.require(:doctor).permit(
        Myp.select_or_create_permit(params[:doctor], :contact_attributes, ContactsController.param_names)
      )
    end
end
