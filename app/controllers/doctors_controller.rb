class DoctorsController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :doctor_type,
      contact_attributes: ContactsController.param_names
    ]
  end

  protected
    def sorts
      ["doctors.updated_at DESC"]
    end

    def obj_params
      params.require(:doctor).permit(
        DoctorsController.param_names
      )
    end
end
