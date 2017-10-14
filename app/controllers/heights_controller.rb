class HeightsController < MyplaceonlineController
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.graphs.graph"),
        link:
          graph_display_path(
            series_1_source: "Heights",
            series_1_values: "in_inches",
            series_1_xvalues: "measurement_date",
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
        [I18n.t("myplaceonline.heights.measurement_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["heights.measurement_date"]
    end

    def obj_params
      params.require(:height).permit(:height_amount, :amount_type, :measurement_date, :measurement_source)
    end
end
