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
        dentist_attributes: DoctorsController.param_names,
        dental_insurance_attributes: DentalInsurancesController.param_names
      )
    end
end
