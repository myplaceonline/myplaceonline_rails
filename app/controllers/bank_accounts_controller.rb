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
      home_address_attributes: LocationsController.param_names,
      bank_account_files_attributes: FilesController.multi_param_names,
    ]
  end

  def may_upload
    true
  end

  protected
    def default_sort_columns
      ["lower(#{model.table_name}.name)"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.bank_accounts.name"), default_sort_columns[0]]
      ]
    end

    def obj_params
      params.require(:bank_account).permit(BankAccountsController.param_names)
    end

    def sensitive
      true
    end
end
