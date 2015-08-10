class HealthInsurancesController < MyplaceonlineController
  def model
    HealthInsurance
  end

  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
  end

  protected
    def sorts
      ["lower(health_insurances.insurance_name) ASC"]
    end

    def obj_params
      params.require(:health_insurance).permit(
        :insurance_name,
        :notes,
        :is_defunct,
        :account_number,
        :group_number,
        Myp.select_or_create_permit(params[:health_insurance], :password_attributes, PasswordsController.param_names),
        Myp.select_or_create_permit(params[:health_insurance], :insurance_company_attributes, CompaniesController.param_names(params[:health_insurance][:insurance_company_attributes])),
        Myp.select_or_create_permit(params[:health_insurance], :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:health_insurance][:periodic_payment_attributes])),
        Myp.select_or_create_permit(params[:health_insurance], :group_company_attributes, CompaniesController.param_names(params[:health_insurance][:group_company_attributes]))
      )
    end

    def create_presave
      update_defunct
    end
    
    def update_presave
      update_defunct
    end

    def before_edit
      @obj.is_defunct = !@obj.defunct.nil?
    end
    
    def update_defunct
      if @obj.is_defunct == "1"
        @obj.defunct = Time.now
      else
        @obj.defunct = nil
      end
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
