class WalletTransactionsController < MyplaceonlineController
  def path_name
    "wallet_wallet_transaction"
  end

  def form_path
    "wallet_transactions/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.wallet_transactions.wallet"),
        link: wallet_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.wallet_transactions.wallet"),
        link: wallet_path(@obj.wallet),
        icon: "back"
      }
    ] + super
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    if !obj.transaction_time.nil?
      Myp.display_datetime(obj.transaction_time, User.current_user)
    else
      Myp.display_datetime(obj.created_at, User.current_user)
    end
  end
  
  protected
    def insecure
      true
    end

    def default_sort_columns
      ["wallet_transactions.created_at"]
    end

    def obj_params
      params.require(:wallet_transaction).permit(WalletTransaction.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Wallet
    end
end
