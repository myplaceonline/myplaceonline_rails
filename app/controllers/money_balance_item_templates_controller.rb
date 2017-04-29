class MoneyBalanceItemTemplatesController < MyplaceonlineController
  def path_name
    "money_balance_money_balance_item_template"
  end

  def form_path
    "money_balance_item_templates/form"
  end
  
  def new
    owner_paid_str = params[:owner_paid].blank? ? "true" : params[:owner_paid]
    @owner_paid = owner_paid_str.to_bool
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
      @parent.contact.display(simple: true)
    else
      @parent.identity.display
    end
  end

  def new_title
    who_paid_title(@owner_paid)
  end

  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.money_balance_item_templates.apply"),
      money_balance_add_path(
                              obj.money_balance,
                              owner_paid: do_calculate_owner_paid(obj) ? "true" : "false",
                              amount: obj.amount.abs,
                              original_amount: obj.amount.abs,
                              percent_default: 1.0,
                              description: obj.money_balance_item_name
                             )
    )
  end

  def do_calculate_owner_paid(obj)
    obj.amount > 0
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.money_balance_item_templates.add_i_paid"),
        link: new_money_balance_money_balance_item_template_path(owner_paid: @parent.current_user_owns? ? "true" : "false"),
        icon: "eye"
      },
      {
        title: I18n.t("myplaceonline.money_balance_item_templates.add_other_paid", { other: self.other_display }),
        link: new_money_balance_money_balance_item_template_path(owner_paid: @parent.current_user_owns? ? "false" : "true"),
        icon: "user"
      },
      {
        title: I18n.t('myplaceonline.money_balance_item_templates.money_balance'),
        link: money_balance_path(@parent),
        icon: "back"
      }
    ]
  end

  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.money_balance_item_templates.money_balance'),
        link: money_balance_path(@obj.money_balance),
        icon: "user"
      },
      {
        title: I18n.t('myplaceonline.money_balance_item_templates.apply'),
        link: money_balance_add_path(@obj.money_balance, owner_paid: self.do_calculate_owner_paid(@obj) ? "true" : "false", amount: @obj.amount.abs, original_amount: @obj.amount.abs, percent_default: 1.0, description: @obj.money_balance_item_name),
        icon: "check"
      }
    ]
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
    
    def additional_items?
      false
    end

    def parent_model
      MoneyBalance
    end
    
    def calculate_owner_paid
      @owner_paid = do_calculate_owner_paid(@obj)
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
