class DentistVisitsController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.dentist_visits.visit_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["dentist_visits.visit_date"]
    end

    def obj_params
      params.require(:dentist_visit).permit(
        :visit_date,
        :cavities,
        :paid,
        :cleaning,
        :notes,
        :xrays_taken,
        dentist_attributes: DoctorsController.param_names,
        dental_insurance_attributes: DentalInsurancesController.param_names
      )
    end
end
