class MyplaceonlineSearchesController < MyplaceonlineController
  def showmyplet
    Myp.log_response_time(
      name: "MyplaceonlineSearchesController.categories_for_current_user",
      threshold: Myp.log_threshold,
    ) do
      @initialCategoryList = Myp.categories_for_current_user(current_user, -1)
    end
  end
  
  protected
    def sorts
      ["myplaceonline_searches.updated_at DESC"]
    end

    def obj_params
      params.require(:myplaceonline_search).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
