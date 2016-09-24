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
  
  protected
    def sorts
      ["credit_scores.score_date DESC"]
    end

    def obj_params
      params.require(:credit_score).permit(:score_date, :score, :source)
    end
end
