class ComputerEnvironmentsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK

  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.computer_environments.computer_environment_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["computer_environments.computer_environment_name"]
    end

    def obj_params
      params.require(:computer_environment).permit(
        :computer_environment_name,
        :computer_environment_type,
        :notes,
      )
    end
end
