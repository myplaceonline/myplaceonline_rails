class DentalInsurancesController < MyplaceonlineController
  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
  end

  protected
    def sorts
      ["lower(dental_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:dental_insurance).permit(
        :insurance_name,
        :notes,
        :is_defunct,
        :account_number,
        :group_number,
        Myp.select_or_create_permit(params[:dental_insurance], :password_attributes, PasswordsController.param_names),
        Myp.select_or_create_permit(params[:dental_insurance], :insurance_company_attributes, CompaniesController.param_names(params[:dental_insurance][:insurance_company_attributes])),
        Myp.select_or_create_permit(params[:dental_insurance], :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:dental_insurance][:periodic_payment_attributes])),
        Myp.select_or_create_permit(params[:dental_insurance], :group_company_attributes, CompaniesController.param_names(params[:dental_insurance][:group_company_attributes])),
        Myp.select_or_create_permit(params[:dental_insurance], :doctor_attributes, DoctorsController.param_names(params[:dental_insurance][:doctor_attributes]))
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
