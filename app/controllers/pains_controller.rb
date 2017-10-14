class PainsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.pains.pain_start_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["pains.pain_start_time"]
    end

    def obj_params
      params.require(:pain).permit(:pain_start_time, :pain_end_time, :pain_location, :intensity, :notes)
    end
end
