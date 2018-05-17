class WalletsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.balance
  end

  def footer_items_show
    result = []

    if !MyplaceonlineExecutionContext.offline?
    end
    
    result << {
      title: I18n.t("myplaceonline.wallets.transactions"),
      link: wallet_wallet_transactions_path(@obj),
      icon: "bars"
    }
    
    result + super
  end
  
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.wallets.wallet_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["wallets.wallet_name"]
    end

    def obj_params
      params.require(:wallet).permit(
        :wallet_name,
        :notes,
        :balance,
        :currency_type,
        wallet_files_attributes: FilesController.multi_param_names,
        password_attributes: PasswordsController.param_names,
        wallet_transactions_attributes: WalletTransaction.params,
      )
    end
end
