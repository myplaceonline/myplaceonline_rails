class BankAccountsController < MyplaceonlineController
  def model
    BankAccount
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(bank_accounts.name) ASC"]
    end

    def obj_params
      params.require(:bank_account).permit(
        :name,
        :account_number,
        :routing_number,
        :pin,
        :encrypt,
        select_or_create_permit(:bank_account, :password_attributes, PasswordsController.param_names),
        select_or_create_permit(:bank_account, :company_attributes, CompaniesController.param_names(params[:bank_account][:company_attributes])),
        select_or_create_permit(:bank_account, :home_address_attributes, LocationsController.param_names)
      )
    end
    
    def create_presave
      if !@obj.password.nil?
        @obj.password.identity = current_user.primary_identity
      end
      if !@obj.home_address.nil?
        @obj.home_address.identity = current_user.primary_identity
      end
      if !@obj.company.nil?
        @obj.company.identity = current_user.primary_identity
      end
    end

    def sensitive
      true
    end

    def create_presave
      @obj.account_number_finalize
      @obj.routing_number_finalize
      @obj.pin_finalize
    end

    def update_presave
      @obj.account_number_finalize
      @obj.routing_number_finalize
      @obj.pin_finalize
    end

    def before_edit
      @obj.encrypt = @obj.account_number_encrypted?
    end
end
