class EmailAccountsController < MyplaceonlineController
  def self.param_names
    [
      password_attributes: PasswordsController.param_names
    ]
  end

  protected
    def sorts
      ["email_accounts.updated_at DESC"]
    end

    def obj_params
      params.require(:email_account).permit(
        EmailAccountsController.param_names
      )
    end

    def insecure
      true
    end
end
