class RewardProgramsController < MyplaceonlineController
  def index
    @program_type = params[:program_type]
    if !@program_type.blank?
      @program_type = @program_type.to_i
    end
    super
  end
  
  def may_upload
    true
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.reward_programs.reward_program_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(reward_programs.reward_program_name)"]
    end

    def all_additional_sql(strict)
      if !@program_type.blank? && !strict
        "and program_type = " + @program_type
      else
        nil
      end
    end
    
    def obj_params
      params.require(:reward_program).permit(
        :reward_program_name,
        :started,
        :ended,
        :reward_program_number,
        :reward_program_status,
        :notes,
        :program_type,
        password_attributes: PasswordsController.param_names,
        reward_program_files_attributes: FilesController.multi_param_names
      )
    end
end
