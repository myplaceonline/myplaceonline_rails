class RetirementPlansController < MyplaceonlineController
  protected
    def sorts
      ["lower(retirement_plans.retirement_plan_name) ASC"]
    end

    def obj_params
      params.require(:retirement_plan).permit(
        :retirement_plan_name,
        :started,
        :notes,
        :retirement_plan_type,
        company_attributes: CompaniesController.param_names,
        periodic_payment_attributes: PeriodicPaymentsController.param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
