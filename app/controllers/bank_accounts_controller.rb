class BankAccountsController < MyplaceonlineController
  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
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
        :is_defunct,
        password_attributes: PasswordsController.param_names,
        company_attributes: CompaniesController.param_names,
        home_address_attributes: LocationsController.param_names
      )
    end

    def sensitive
      true
    end

    def all_additional_sql(strict)
      if (@defunct.blank? || !@defunct) && !strict
        "and defunct is null"
      else
        nil
      end
    end
end
