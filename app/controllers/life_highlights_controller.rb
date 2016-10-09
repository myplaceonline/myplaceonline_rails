class LifeHighlightsController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.life_highlight_time, User.current_user)
  end
    
  protected
    def insecure
      true
    end

    def sorts
      ["life_highlights.life_highlight_time DESC", "lower(life_highlights.life_highlight_name) ASC"]
    end

    def obj_params
      params.require(:life_highlight).permit(
        :life_highlight_time,
        :life_highlight_name,
        :notes
      )
    end
end
