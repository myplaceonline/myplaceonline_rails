class WeightsController < MyplaceonlineController
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.graphs.graph"),
        link:
          graph_display_path(
            series_1_source: "Weights",
            series_1_values: "in_pounds",
            series_1_xvalues: "measure_date",
            hideform: "true"
          ),
        icon: "grid"
      }
    ]
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
        [I18n.t("myplaceonline.weights.measure_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["weights.measure_date"]
    end

    def obj_params
      params.require(:weight).permit(:amount, :amount_type, :measure_date, :source)
    end
end
