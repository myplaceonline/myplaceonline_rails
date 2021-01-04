class AirlineProgramsController < MyplaceonlineController
  def split_link(obj)
    if !obj.password.nil? && !obj.password.url.blank?
      ActionController::Base.helpers.link_to(
        I18n.t("myplaceonline.airline_programs.website"),
        obj.password.url,
      )
    else
      nil
    end
  end
  
  def data_split_icon
    "action"
  end
  
  protected
    def default_sort_direction
      "asc"
    end

    def default_sort_columns
      ["airline_programs.program_name"]
    end

    def obj_params
      params.require(:airline_program).permit(
        :program_name,
        :status,
        :notes,
        :rating,
        password_attributes: PasswordsController.param_names,
        membership_attributes: MembershipsController.param_names,
      )
    end
end
