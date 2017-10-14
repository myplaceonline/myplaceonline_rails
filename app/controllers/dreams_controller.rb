class DreamsController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.dreams.dream_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["dreams.dream_time"]
    end

    def sensitive
      true
    end

    def obj_params
      params.require(:dream).permit(
        :dream_name,
        :dream_time,
        :dream,
        :encrypt
      )
    end
end
