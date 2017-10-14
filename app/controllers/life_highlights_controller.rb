class LifeHighlightsController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.life_highlight_time, User.current_user)
  end
    
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.life_highlights.life_highlight_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["life_highlights.life_highlight_time", "lower(life_highlights.life_highlight_name) ASC"]
    end

    def obj_params
      params.require(:life_highlight).permit(
        :life_highlight_time,
        :life_highlight_name,
        :notes,
        life_highlight_files_attributes: FilesController.multi_param_names
      )
    end
end
