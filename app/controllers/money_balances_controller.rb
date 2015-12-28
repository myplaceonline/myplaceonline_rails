class MoneyBalancesController < MyplaceonlineController
  def self.param_names(params)
    [
      Myp.select_or_create_permit(params, :contact_attributes, ContactsController.param_names),
      :notes,
      money_balance_items_attributes: [
        :id,
        :_destroy,
        :money_balance_item_name,
        :amount,
        :item_time
      ]
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "contact_attributes"
        ContactsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  protected
    def sorts
      ["money_balances.updated_at DESC"]
    end

    def obj_params
      params.require(:money_balance).permit(
        MoneyBalancesController.param_names(params[:money_balance])
      )
    end
end
