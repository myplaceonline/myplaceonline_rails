class PermissionsController < MyplaceonlineController
  def self.param_names(params)
    [
      Myp.select_or_create_permit(params, :contact_attributes, ContactsController.param_names),
      :action,
      :subject_class,
      :subject_id
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
      ["permissions.updated_at DESC"]
    end

    def obj_params
      params.require(:permission).permit(
        PermissionsController.param_names(params[:permission])
      )
    end
end
