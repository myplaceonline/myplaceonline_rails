class LifeHighlightsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(life_highlights.life_highlight_name) ASC"]
    end

    def obj_params
      params.require(:life_highlight).permit(
        :life_highlight_time,
        :life_highlight_name,
        :notes
      )
    end
end
