class MoneyBalanceItemsController < MyplaceonlineController
  def path_name
    "money_balance_money_balance_item"
  end

  def form_path
    "money_balance_items/form"
  end

  protected
    def sorts
      ["money_balance_items.item_time DESC"]
    end

    def obj_params
      params.require(:money_balance_item).permit(
        :amount,
        :item_time,
        :money_balance_item_name,
        :notes,
        :original_amount
      )
    end
    
    def has_category
      false
    end
    
    def nested
      true
    end
    
    def additional_items?
      false
    end

    def parent_model
      MoneyBalance
    end
end
