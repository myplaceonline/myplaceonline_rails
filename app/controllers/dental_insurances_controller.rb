class DentalInsurancesController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :insurance_name,
      :notes,
      :is_archived,
      :account_number,
      :group_number,
      password_attributes: PasswordsController.param_names,
      insurance_company_attributes: CompaniesController.param_names,
      periodic_payment_attributes: PeriodicPaymentsController.param_names,
      group_company_attributes: CompaniesController.param_names,
      doctor_attributes: DoctorsController.param_names
    ]
  end

  def self.reject_if_blank(attributes)
    result = attributes.dup.delete_if {|key, value| key.to_s == "is_archived" }.all?{|key, value|
      if key == "password_attributes"
        PasswordsController.reject_if_blank(value)
      elsif key == "insurance_company_attributes" || key == "group_company_attributes"
        CompaniesController.reject_if_blank(value)
      elsif key == "doctor_attributes"
        DoctorsController.reject_if_blank(value)
      elsif key == "periodic_payment_attributes"
        PeriodicPaymentsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
    result
  end

  protected
    def sorts
      ["lower(dental_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:dental_insurance).permit(
        DentalInsurancesController.param_names
      )
    end
end
