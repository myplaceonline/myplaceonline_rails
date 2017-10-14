class ProblemReportsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.problem_reports.report_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(problem_reports.report_name)"]
    end

    def obj_params
      params.require(:problem_report).permit(
        :report_name,
        :notes,
        problem_report_files_attributes: FilesController.multi_param_names
      )
    end
end
