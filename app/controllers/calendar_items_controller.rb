class CalendarItemsController < MyplaceonlineController
  def path_name
    "calendar_calendar_item"
  end

  def form_path
    "calendar_items/form"
  end
  
  def use_bubble?
    true
  end

  def bubble_text(obj)
    Myp.display_datetime(obj.calendar_item_time, current_user)
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t('myplaceonline.calendar_items.calendar'),
        link: calendar_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t('myplaceonline.calendar_items.calendar'),
        link: calendar_path(@obj.calendar),
        icon: "back"
      },
      {
        title: I18n.t('myplaceonline.calendar_items.calendar_item_reminders'),
        link: calendar_calendar_item_calendar_item_reminders_path(@obj.calendar, @obj),
        icon: "grid"
      }
    ] + super
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.calendar_items.calendar_item_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["calendar_items.calendar_item_time"]
    end

    def obj_params
      params.require(:calendar_item).permit(
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
      Calendar
    end
    
    def get_default_offset
      t = User.current_user.time_now + 1.weeks
      all.order(sorts_wrapper).to_a.index{|calendar_item| calendar_item.calendar_item_time.nil? ? -1 : t >= calendar_item.calendar_item_time }
    end
end
