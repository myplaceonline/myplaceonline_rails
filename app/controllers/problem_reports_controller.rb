class ProblemReportsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(problem_reports.report_name) ASC"]
    end

    def obj_params
      params.require(:problem_report).permit(
        :report_name,
        :notes,
        problem_report_files_attributes: FilesController.multi_param_names
      )
    end
end
