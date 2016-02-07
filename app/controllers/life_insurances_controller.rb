class LifeInsurancesController < MyplaceonlineController
  protected
    def sorts
      ["lower(life_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:life_insurance).permit(
        :insurance_name,
        :insurance_amount,
        :started,
        :notes,
        :life_insurance_type,
        company_attributes: CompaniesController.param_names,
        periodic_payment_attributes: PeriodicPaymentsController.param_names
      )
    end
end
