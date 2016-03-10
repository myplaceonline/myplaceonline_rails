class SpecialistsController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :specialist_type,
      contact_attributes: ContactsController.param_names
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
      ["specialists.updated_at DESC"]
    end

    def obj_params
      params.require(:specialist).permit(
        SpecialistsController.param_names
      )
    end
end
