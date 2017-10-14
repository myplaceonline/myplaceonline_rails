class HeadachesController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.headaches.started"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["headaches.started"]
    end

    def obj_params
      params.require(:headache).permit(
        :started,
        :ended,
        :intensity,
        :headache_location
      )
    end
end
