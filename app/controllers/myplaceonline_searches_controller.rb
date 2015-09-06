class MyplaceonlineSearchesController < MyplaceonlineController
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
