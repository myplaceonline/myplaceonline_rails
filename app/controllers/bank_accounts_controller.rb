class BankAccountsController < MyplaceonlineController
  def index
    @archived = params[:archived]
    if !@archived.blank?
      @archived = @archived.to_bool
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
        :is_archived,
        password_attributes: PasswordsController.param_names,
        company_attributes: CompaniesController.param_names,
        home_address_attributes: LocationsController.param_names
      )
    end

    def sensitive
      true
    end

    def all_additional_sql(strict)
      if (@archived.blank? || !@archived) && !strict
        "and archived is null"
      else
        nil
      end
    end
end
