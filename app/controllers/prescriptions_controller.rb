class PrescriptionsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.prescription_date, User.current_user)
  end

  protected
    def sorts
      ["prescriptions.prescription_date DESC NULLS FIRST", "lower(prescriptions.prescription_name) ASC"]
    end

    def obj_params
      params.require(:prescription).permit(
        :prescription_name,
        :prescription_date,
        :notes,
        :refill_maximum,
        doctor_attributes: DoctorsController.param_names,
        prescription_files_attributes: FilesController.multi_param_names,
        prescription_refills_attributes: PrescriptionRefill.params
      )
    end
end
