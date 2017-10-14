class MedicineUsagesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.medicine_usages.usage_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["medicine_usages.usage_time"]
    end

    def obj_params
      params.require(:medicine_usage).permit(
        :usage_time,
        :usage_notes,
        medicine_usage_medicines_attributes: [
          :id,
          :_destroy,
          medicine_attributes: Medicine.params
        ]
      )
    end
end
