class MoneyBalanceItemTemplatesController < MyplaceonlineController
  def path_name
    "money_balance_money_balance_item_template"
  end

  def form_path
    "money_balance_item_templates/form"
  end

  protected
    def sorts
      ["money_balance_item_templates.amount ASC"]
    end

    def obj_params
      params.require(:money_balance_item_template).permit(
        :amount,
        :original_amount,
        :money_balance_item_name,
        :notes
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
