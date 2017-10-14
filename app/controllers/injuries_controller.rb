class InjuriesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.injury_date, User.current_user)
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.injuries.injury_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["injuries.injury_date"]
    end

    def obj_params
      params.require(:injury).permit(
        :injury_name,
        :injury_date,
        :notes,
        location_attributes: LocationsController.param_names,
        injury_files_attributes: FilesController.multi_param_names
      )
    end
end
