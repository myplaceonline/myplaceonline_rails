class MyplaceonlineQuickCategoryDisplaysController < MyplaceonlineController
  
  RECENTLY_VISITED_CATEGORIES_DEFAULT_MAXIMUM = 5
  MOST_VISITED_CATEGORIES_DEFAULT_MAXIMUM = 5
  MOST_VISITED_ITEMS_DEFAULT_MAXIMUM = 5
  ABSOLUTE_MAXIMUM = 50
  
  def showmyplet
    recently_visited_categories = current_user.recently_visited_categories
    if recently_visited_categories.nil?
      recently_visited_categories = MyplaceonlineQuickCategoryDisplaysController::RECENTLY_VISITED_CATEGORIES_DEFAULT_MAXIMUM
    end
    most_visited_categories = current_user.most_visited_categories
    if most_visited_categories.nil?
      most_visited_categories = MyplaceonlineQuickCategoryDisplaysController::MOST_VISITED_CATEGORIES_DEFAULT_MAXIMUM
    end
    most_visited_items = current_user.most_visited_items
    if most_visited_items.nil?
      most_visited_items = MyplaceonlineQuickCategoryDisplaysController::MOST_VISITED_ITEMS_DEFAULT_MAXIMUM
    end

    @usefulCategoryList = Myp.useful_categories(current_user, recently_visited_categories, most_visited_categories)
    @usefulItemsList = Myp.highly_visited(current_user, limit: most_visited_items).first(most_visited_items)
    if @usefulCategoryList.length == 0 && @usefulItemsList.length == 0
      @nocontent = true
    end
  end
  
  protected
    def sorts
      ["myplaceonline_quick_category_displays.updated_at DESC"]
    end

    def obj_params
      params.require(:myplaceonline_quick_category_display).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
