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

  protected
    def sorts
      ["calendar_items.calendar_item_time DESC"]
    end

    def obj_params
      params.require(:calendar_item).permit(
        :trash
      )
    end
    
    def has_category
      false
    end
    
    def nested
      true
    end
    
    def additional_items?
      false
    end

    def parent_model
      Calendar
    end
end
