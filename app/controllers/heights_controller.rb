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

    def sorts
      ["heights.measurement_date DESC"]
    end

    def obj_params
      params.require(:height).permit(:height_amount, :amount_type, :measurement_date, :measurement_source)
    end
end
