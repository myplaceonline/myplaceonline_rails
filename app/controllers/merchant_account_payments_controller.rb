class MerchantAccountInstancesController < MyplaceonlineController
  def path_name
    "merchant_account_merchant_account_payment"
  end

  def form_path
    "merchant_account_payments/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.merchant_account_payments.back"),
        link: test_object_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.merchant_account_payments.back"),
        link: test_object_path(@obj.merchant_account),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.merchant_account_payments.payment_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(merchant_account_payments.payment_name)"]
    end

    def obj_params
      params.require(:merchant_account_payment).permit(MerchantAccountPayment.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      MerchantAccount
    end
end
