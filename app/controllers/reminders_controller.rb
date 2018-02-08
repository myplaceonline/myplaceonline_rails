class RemindersController < MyplaceonlineController
  def footer_items_show
    result = super
    
    if !@obj.calendar_item.nil?
      result << {
        title: I18n.t("myplaceonline.reminders.calendar_item"),
        link: calendar_calendar_item_path(@obj.calendar_item.calendar, @obj.calendar_item),
        icon: "calendar"
      }
    end
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.reminders.refresh"),
        link: reminder_refresh_path(@obj),
        icon: "refresh"
      }
    end
    
    result
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.start_time, User.current_user)
  end
  
  def self.param_names
    [
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
    ]
  end
  
  def refresh
    set_obj
    @obj.on_after_save
    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.reminders.refreshed") }
    )
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
        [I18n.t("myplaceonline.reminders.start_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["reminders.start_time"]
    end

    def obj_params
      params.require(:reminder).permit(RemindersController.param_names)
    end
end
