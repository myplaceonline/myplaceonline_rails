class HealthInsurancesController < MyplaceonlineController
  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :insurance_name,
      :notes,
      :is_defunct,
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
    result = attributes.dup.delete_if {|key, value| key.to_s == "is_defunct" }.all?{|key, value|
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
      ["lower(health_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:health_insurance).permit(
        HealthInsurancesController.param_names
      )
    end

    def all_additional_sql
      if @defunct.blank? || !@defunct
        "and defunct is null"
      else
        nil
      end
    end
end
