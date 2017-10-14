class SunExposuresController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.sun_exposures.exposure_start"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["sun_exposures.exposure_start"]
    end

    def obj_params
      params.require(:sun_exposure).permit(:exposure_start, :exposure_end, :sunscreened_body_parts, :uncovered_body_parts, :sunscreen_type)
    end
end
