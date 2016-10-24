class EmailAccountsController < MyplaceonlineController
  def self.param_names
    [
      password_attributes: PasswordsController.param_names
    ]
  end

  def search_index_name
    Password.table_name
  end

  def search_parent_category
    category_name.singularize
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

    def sensitive
      true
    end
end
