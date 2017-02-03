class BankAccountsController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :account_number,
      :routing_number,
      :pin,
      :encrypt,
      password_attributes: PasswordsController.param_names,
      company_attributes: Company.param_names,
      home_address_attributes: LocationsController.param_names
    ]
  end

  protected
    def sorts
      ["lower(bank_accounts.name) ASC"]
    end

    def obj_params
      params.require(:bank_account).permit(BankAccountsController.param_names)
    end

    def sensitive
      true
    end
end
