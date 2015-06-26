class LifeInsurancesController < MyplaceonlineController
  def model
    LifeInsurance
  end

  def display_obj(obj)
    obj.display
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
        Myp.select_or_create_permit(params[:life_insurance], :company_attributes, CompaniesController.param_names(params[:life_insurance][:company_attributes])),
        Myp.select_or_create_permit(params[:life_insurance], :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:life_insurance][:periodic_payment_attributes]))
      )
    end
end
