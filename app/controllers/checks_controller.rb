class ChecksController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def sorts
      ["lower(checks.description) ASC"]
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
        company_attributes: CompaniesController.param_names,
        bank_account_attributes: BankAccountsController.param_names,
      )
    end
end
