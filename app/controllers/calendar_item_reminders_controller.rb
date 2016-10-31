class CalendarItemRemindersController < MyplaceonlineController
  def path_name
    "calendar_calendar_item_calendar_item_reminder"
  end

  def form_path
    "calendar_item_reminders/form"
  end
  
  def show_path(obj)
    send("#{path_name}_path", obj.calendar_item.calendar, obj.calendar_item, obj)
  end

  def obj_path(obj = @obj)
    send(path_name + "_path", obj.calendar_item.calendar, obj.calendar_item, obj)
  end
  
  def edit_obj_path(obj = @obj)
    send("edit_" + path_name + "_path", obj.calendar_item.calendar, obj.calendar_item, obj)
  end

  def nested
    true
  end
    
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.calendar_item_reminders.calendar_item"),
        link: calendar_calendar_item_path(@parent.calendar, @parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.calendar_item_reminders.calendar_item"),
        link: calendar_calendar_item_path(@obj.calendar_item.calendar, @obj.calendar_item),
        icon: "back"
      },
      {
        title: I18n.t("myplaceonline.calendar_item_reminders.calendar_item_reminder_pendings"),
        link: calendar_calendar_item_calendar_item_reminder_calendar_item_reminder_pendings_path(@obj.calendar_item.calendar, @obj.calendar_item, @obj),
        icon: "grid"
      }
    ]
  end
  
  protected
    def sorts
      ["calendar_item_reminders.updated_at DESC"]
    end

    def obj_params
      params.require(:calendar_item_reminder).permit(
        :trash
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      [Calendar, CalendarItem]
    end
end
