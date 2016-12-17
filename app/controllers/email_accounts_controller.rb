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

    def sorts
      sorts_helper{["lower(passwords.name) ASC"]}
    end
    
    def all_joins
      "INNER JOIN passwords ON passwords.id = email_accounts.password_id"
    end

    def all_includes
      :password
    end
end
