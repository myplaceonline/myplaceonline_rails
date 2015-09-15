class MyplaceonlineSearchesController < MyplaceonlineController
  def showmyplet
    @initialCategoryList = Myp.categories_for_current_user(current_user, -1).to_json
    super
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
