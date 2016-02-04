class MoneyBalanceItemTemplatesController < MyplaceonlineController
  def path_name
    "money_balance_money_balance_item_template"
  end

  def form_path
    "money_balance_item_templates/form"
  end
  
  def new
    onwer_paid_str = params[:owner_paid].blank? ? "true" : params[:owner_paid]
    @owner_paid = onwer_paid_str.to_bool
    super
  end

  def who_paid_title(owner_paid)
    MoneyBalancesController.who_paid_title(@parent, owner_paid)
  end
  
  def other_owed_name(owner_paid)
    MoneyBalancesController.other_owed_name(@parent, owner_paid)
  end
  
  def other_display
    if @parent.current_user_owns?
      @parent.contact.display
    else
      @parent.identity.display
    end
  end

  def new_title
    who_paid_title(@owner_paid)
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
        :notes,
        :invert
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
    
    def calculate_owner_paid
      @owner_paid = @obj.amount < 0 ? (@obj.current_user_owns? ? false : true) : (@obj.current_user_owns? ? true : false)
    end

    def edit_prerespond
      calculate_owner_paid
      @obj.amount = @obj.amount.abs
      @obj.original_amount = @obj.original_amount.abs
    end
    
    def before_show
      calculate_owner_paid
      super
    end
end
