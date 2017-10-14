class PsychologicalEvaluationsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.evaluation_date, User.current_user)
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.psychological_evaluations.evaluation_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["psychological_evaluations.evaluation_date"]
    end

    def obj_params
      params.require(:psychological_evaluation).permit(
        :psychological_evaluation_name,
        :evaluation_date,
        :score,
        :evaluation,
        psychological_evaluation_files_attributes: FilesController.multi_param_names,
        evaluator_attributes: ContactsController.param_names
      )
    end
end
