class HealthInsurancesController < MyplaceonlineController
  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
  end

  def self.param_names(params)
    if params.nil? || (params.length == 1 && !params["id"].nil?)
      return []
    end
    [
      :insurance_name,
      :notes,
      :is_defunct,
      :account_number,
      :group_number,
      Myp.select_or_create_permit(params, :password_attributes, PasswordsController.param_names),
      Myp.select_or_create_permit(params, :insurance_company_attributes, CompaniesController.param_names(params[:insurance_company_attributes])),
      Myp.select_or_create_permit(params, :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:periodic_payment_attributes])),
      Myp.select_or_create_permit(params, :group_company_attributes, CompaniesController.param_names(params[:group_company_attributes])),
      Myp.select_or_create_permit(params, :doctor_attributes, DoctorsController.param_names(params[:doctor_attributes]))
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
        HealthInsurancesController.param_names(params[:health_insurance])
      )
    end

    def all
      if @defunct.blank? || !@defunct
        model.where("owner_id = ? and defunct is null", current_user.primary_identity)
      else
        model.where(
          owner_id: current_user.primary_identity.id
        )
      end
    end
end
