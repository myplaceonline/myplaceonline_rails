class RemindersController < MyplaceonlineController
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.reminders.calendar_item"),
        link: calendar_calendar_item_path(@obj.calendar_item.calendar, @obj.calendar_item),
        icon: "calendar"
      },
    ]
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.start_time, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["reminders.start_time DESC"]
    end

    def obj_params
      params.require(:reminder).permit(
        :start_time,
        :reminder_name,
        :reminder_threshold_amount,
        :reminder_threshold_type,
        :expire_amount,
        :expire_type,
        :repeat_amount,
        :repeat_type,
        :max_pending,
        :notes,
      )
    end
end
