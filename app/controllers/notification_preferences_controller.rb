class NotificationPreferencesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.general.updated_at"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["notification_preferences.updated_at"]
    end

    def obj_params
      params.require(:notification_preference).permit(
        :notification_type,
        :notification_category,
        :notifications_enabled,
        :notes,
      )
    end
end
