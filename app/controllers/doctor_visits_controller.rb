class DoctorVisitsController < MyplaceonlineController
  def may_upload
    true
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.doctor_visits.visit_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["doctor_visits.visit_date"]
    end

    def obj_params
      params.require(:doctor_visit).permit(
        :visit_date,
        :paid,
        :physical,
        :notes,
        doctor_attributes: DoctorsController.param_names,
        health_insurance_attributes: HealthInsurancesController.param_names,
        doctor_visit_files_attributes: FilesController.multi_param_names
      )
    end
end
