class VaccinesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.vaccine_date, User.current_user)
  end
    
  protected
    def insecure
      true
    end

    def sorts
      ["vaccines.vaccine_date DESC NULLS LAST", "lower(vaccines.vaccine_name) ASC"]
    end

    def obj_params
      params.require(:vaccine).permit(
        :vaccine_name,
        :vaccine_date,
        :notes,
        vaccine_files_attributes: FilesController.multi_param_names
      )
    end
end
