class TherapistsController < MyplaceonlineController
  protected

    def sorts
      ["therapists.updated_at DESC"]
    end

    def obj_params
      params.require(:therapist).permit(
        Myp.select_or_create_permit(params[:therapist], :contact_attributes, ContactsController.param_names)
      )
    end
end
