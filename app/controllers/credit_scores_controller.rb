class CreditScoresController < MyplaceonlineController
  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.graphs.graph'),
        link:
          graph_display_path(
            series_1_source: "Credit Scores",
            series_1_values: "score",
            series_1_xvalues: "score_date",
            hideform: "true"
          ),
        icon: "grid"
      }
    ]
  end
  
  def may_upload
    true
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.credit_scores.score_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["credit_scores.score_date"]
    end

    def obj_params
      params.require(:credit_score).permit(
        :score_date,
        :score,
        :source,
        credit_score_files_attributes: FilesController.multi_param_names
      )
    end
end
