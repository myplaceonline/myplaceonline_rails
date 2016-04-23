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
    
    def get_default_offset
      t = User.current_user.time_now + 1.weeks
      all.order(sorts).index{|calendar_item| puts "T: #{calendar_item.calendar_item_time}"; t >= calendar_item.calendar_item_time }
    end
end
