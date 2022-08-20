class MerchantAccountsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.merchant_accounts.merchant_account_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["merchant_accounts.merchant_account_name"]
    end

    def obj_params
      params.require(:merchant_account).permit(
        :merchant_account_name,
        :limit_daily,
        :limit_monthly,
        :currencies_accepted,
        :ship_to_countries,
        :notes,
        :rating,
        merchant_account_files_attributes: FilesController.multi_param_names,
      )
    end
end
