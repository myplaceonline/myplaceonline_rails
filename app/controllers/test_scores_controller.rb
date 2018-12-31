class TestScoresController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.test_score_date, User.current_user)
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
        [I18n.t("myplaceonline.test_scores.test_score_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["test_scores.test_score_date", "lower(test_scores.test_score_name)"]
    end

    def obj_params
      params.require(:test_score).permit(
        :test_score_name,
        :test_score_date,
        :test_score,
        :notes,
        :percentile,
        test_score_files_attributes: FilesController.multi_param_names
      )
    end
end
