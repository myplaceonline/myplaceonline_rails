class DoctorsController < MyplaceonlineController
  def self.param_names(params)
    [
      :doctor_type,
      Myp.select_or_create_permit(params, :contact_attributes, ContactsController.param_names)
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "contact_attributes"
        ContactsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  protected
    def sorts
      ["doctors.updated_at DESC"]
    end

    def obj_params
      params.require(:doctor).permit(
        DoctorsController.param_names(params[:doctor])
      )
    end
end
