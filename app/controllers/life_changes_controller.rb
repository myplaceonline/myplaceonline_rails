class LifeChangesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.start_day, User.current_user)
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
        [I18n.t("myplaceonline.life_changes.start_day"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["life_changes.start_day"]
    end

    def obj_params
      params.require(:life_change).permit(
        :life_change_title,
        :start_day,
        :end_day,
        :notes,
        :rating,
        life_change_files_attributes: FilesController.multi_param_names,
      )
    end
end
