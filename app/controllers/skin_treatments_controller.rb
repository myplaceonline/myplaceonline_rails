class SkinTreatmentsController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.skin_treatments.treatment_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["skin_treatments.treatment_time"]
    end

    def obj_params
      params.require(:skin_treatment).permit(
        :treatment_time,
        :treatment_activity,
        :treatment_location
      )
    end
end
