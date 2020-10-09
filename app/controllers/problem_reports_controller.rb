class ProblemReportsController < MyplaceonlineController
  def may_upload
    true
  end

  def bubble_text(obj)
    Myp.display_datetime_short_year(obj.problem_started, User.current_user)
  end

  def use_bubble?
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.problem_reports.problem_started"), default_sort_columns[0]],
        [I18n.t("myplaceonline.problem_reports.report_name"), default_sort_columns[1]],
      ]
    end

    def default_sort_columns
      ["problem_reports.problem_started", "lower(problem_reports.report_name)"]
    end
    
    def default_sorts_additions
      "nulls last"
    end

    def obj_params
      params.require(:problem_report).permit(
        :report_name,
        :notes,
        :problem_started,
        :problem_resolved,
        problem_report_files_attributes: FilesController.multi_param_names
      )
    end
end
