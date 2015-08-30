class DoctorVisitsController < MyplaceonlineController
  protected
    def sorts
      ["doctor_visits.visit_date DESC"]
    end

    def obj_params
      params.require(:doctor_visit).permit(
        :visit_date,
        :paid,
        :physical,
        :notes,
        Myp.select_or_create_permit(params[:doctor_visit], :doctor_attributes, DoctorsController.param_names(params[:doctor_visit][:doctor_attributes])),
        Myp.select_or_create_permit(params[:doctor_visit], :health_insurance_attributes, HealthInsurancesController.param_names(params[:doctor_visit][:health_insurance_attributes]))
      )
    end
end
