class MyplaceonlineQuickCategoryDisplaysController < MyplaceonlineController
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
