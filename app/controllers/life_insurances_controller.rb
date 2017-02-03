class LifeInsurancesController < MyplaceonlineController
  def may_upload
    true
  end
  
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
        :cash_value,
        :loan_interest_rate,
        company_attributes: Company.param_names,
        periodic_payment_attributes: PeriodicPaymentsController.param_names,
        life_insurance_files_attributes: FilesController.multi_param_names,
        beneficiary_attributes: ContactsController.param_names
      )
    end
end
