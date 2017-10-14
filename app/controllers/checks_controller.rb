class ChecksController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.checks.description"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(checks.description)"]
    end

    def obj_params
      params.require(:check).permit(
        :description,
        :notes,
        :amount,
        :deposit_date,
        :received_date,
        check_files_attributes: FilesController.multi_param_names,
        contact_attributes: ContactsController.param_names,
        company_attributes: Company.param_names,
        bank_account_attributes: BankAccountsController.param_names,
      )
    end
end
