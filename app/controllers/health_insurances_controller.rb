class HealthInsurancesController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :insurance_name,
      :notes,
      :account_number,
      :group_number,
      password_attributes: PasswordsController.param_names,
      insurance_company_attributes: CompaniesController.param_names,
      periodic_payment_attributes: PeriodicPaymentsController.param_names,
      group_company_attributes: CompaniesController.param_names,
      doctor_attributes: DoctorsController.param_names,
      health_insurance_files_attributes: FilesController.multi_param_names
    ]
  end

  def self.reject_if_blank(attributes)
    result = attributes.dup.all?{|key, value|
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

  def may_upload
    true
  end

  protected
    def sorts
      ["lower(health_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:health_insurance).permit(
        HealthInsurancesController.param_names
      )
    end

    def sensitive
      true
    end
end
