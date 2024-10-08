class StatusesController < MyplaceonlineController

  DISABLE_REMINDERS = :disable_reminders

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.menu.home"),
        link: root_path,
        icon: "home"
      },
    ] + super
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.statuses.status_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["statuses.status_time"]
    end

    def obj_params
      params.require(:status).permit(
        :status_time,
        :three_good_things,
        :feeling,
        :status1,
        :status2,
        :status3,
        :stoic_ailments,
        :stoic_failings,
        :stoic_failed,
        :stoic_duties,
        :stoic_improvement,
        :stoic_faults,
      )
    end
    
    def settings_fields
      super + [
        {
          type: Myp::FIELD_BOOLEAN,
          name: DISABLE_REMINDERS,
          options: {
            value: @disable_reminders,
            placeholder: "myplaceonline.statuses.setting_disable_reminders",
          },
        },
      ]
    end

    def load_settings_params
      super
      @disable_reminders = settings_boolean(name: DISABLE_REMINDERS, default_value: false)
    end
end
