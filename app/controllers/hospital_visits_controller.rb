class HospitalVisitsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.hospital_visit_date, User.current_user)
  end

  protected
    def sorts
      ["hospital_visits.hospital_visit_date DESC"]
    end

    def obj_params
      params.require(:hospital_visit).permit(
        :hospital_visit_purpose,
        :hospital_visit_date,
        :emergency_room,
        :notes,
        hospital_attributes: LocationsController.param_names,
        hospital_visit_files_attributes: FilesController.multi_param_names
      )
    end
end
