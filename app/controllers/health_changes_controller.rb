class HealthChangesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.change_date, User.current_user)
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
        [I18n.t("myplaceonline.health_changes.change_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["health_changes.change_date"]
    end

    def obj_params
      params.require(:health_change).permit(
        :change_name,
        :change_date,
        :notes,
        :rating,
        health_change_files_attributes: FilesController.multi_param_names,
      )
    end
end
