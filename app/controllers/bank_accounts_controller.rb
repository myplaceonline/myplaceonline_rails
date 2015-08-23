class BankAccountsController < MyplaceonlineController
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
        Myp.select_or_create_permit(params[:bank_account], :password_attributes, PasswordsController.param_names),
        Myp.select_or_create_permit(params[:bank_account], :company_attributes, CompaniesController.param_names(params[:bank_account][:company_attributes])),
        Myp.select_or_create_permit(params[:bank_account], :home_address_attributes, LocationsController.param_names)
      )
    end

    def sensitive
      true
    end
end
