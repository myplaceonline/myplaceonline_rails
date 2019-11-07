class CrontabsController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.crontabs.crontab_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["crontabs.crontab_name"]
    end

    def obj_params
      params.require(:crontab).permit(
        :crontab_name,
        :dblocker,
        :run_class,
        :run_method,
        :minutes,
        :last_success,
        :run_data,
        :notes,
      )
    end
end
