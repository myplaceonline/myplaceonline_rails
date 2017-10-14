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
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.prescriptions.prescription_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["prescriptions.prescription_date", "lower(prescriptions.prescription_name) ASC"]
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
