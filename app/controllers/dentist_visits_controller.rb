class DentistVisitsController < MyplaceonlineController
  protected
    def sorts
      ["dentist_visits.visit_date DESC"]
    end

    def obj_params
      params.require(:dentist_visit).permit(
        :visit_date,
        :cavities,
        :paid,
        :cleaning,
        :notes,
        Myp.select_or_create_permit(params[:dentist_visit], :dentist_attributes, DoctorsController.param_names(params[:dentist_visit][:dentist_attributes])),
        Myp.select_or_create_permit(params[:dentist_visit], :dental_insurance_attributes, DentalInsurancesController.param_names(params[:dentist_visit][:dental_insurance_attributes]))
      )
    end
end
