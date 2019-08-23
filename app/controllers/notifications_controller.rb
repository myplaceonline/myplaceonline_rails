class NotificationsController < MyplaceonlineController
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
      ["notifications.updated_at"]
    end

    def obj_params
      params.require(:notification).permit(
        :notification_subject,
        :notification_text,
        :notification_type,
        :notification_category,
        :notes,
      )
    end
end
