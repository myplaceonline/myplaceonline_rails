class SurgeriesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.surgery_date, User.current_user)
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.surgeries.surgery_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["surgeries.surgery_date"]
    end

    def obj_params
      params.require(:surgery).permit(
        :surgery_name,
        :surgery_date,
        :notes,
        doctor_attributes: DoctorsController.param_names,
        hospital_attributes: LocationsController.param_names,
        surgery_files_attributes: FilesController.multi_param_names
      )
    end
end
