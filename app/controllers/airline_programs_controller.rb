class AirlineProgramsController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
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
