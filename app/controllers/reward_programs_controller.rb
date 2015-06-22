class RewardProgramsController < MyplaceonlineController
  def model
    RewardProgram
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(reward_programs.reward_program_name) ASC"]
    end

    def obj_params
      params.require(:reward_program).permit(
        :reward_program_name,
        :started,
        :ended,
        :reward_program_number,
        :reward_program_status,
        :notes,
        Myp.select_or_create_permit(params[:reward_program], :password_attributes, PasswordsController.param_names),
      )
    end
end
