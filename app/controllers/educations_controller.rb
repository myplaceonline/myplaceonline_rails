class EducationsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.education_end, User.current_user)
  end
    
  protected
    def insecure
      true
    end

    def sorts
      ["educations.education_end DESC"]
    end

    def obj_params
      params.require(:education).permit(
        :education_name,
        :education_start,
        :education_end,
        :degree_name,
        :gpa,
        :notes,
        location_attributes: LocationsController.param_names,
        education_files_attributes: FilesController.multi_param_names
      )
    end
end
