class MoneyBalancesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:add, :list]

  def self.param_names
    [
      :id,
      :_destroy,
      :notes,
      contact_attributes: ContactsController.param_names,
      money_balance_items_attributes: [
        :id,
        :_destroy,
        :money_balance_item_name,
        :amount,
        :original_amount,
        :item_time,
        :invert,
        :notes,
        :original_amount_humanized,
      ]
    ]
  end
  
  def list
    set_obj
  end
  
  def add
    check_password

    set_obj
    # X paid a bill and Y either owes 100%, 50%, or some other percent
    owner_paid_str = params[:owner_paid].blank? ? "true" : params[:owner_paid]
    @owner_paid = owner_paid_str.to_bool
    @amount = params[:amount]
    @original_amount = params[:original_amount_humanized]
    @description = params[:description]
    @checkbox_percent100 = " checked=\"checked\""
    @checkbox_percent75 = params[:percent_default] == "0.25" ? " checked=\"checked\"" : ""
    @checkbox_percent50 = params[:percent_default] == "0.5" ? " checked=\"checked\"" : ""
    @checkbox_percent25 = params[:percent_default] == "0.75" ? " checked=\"checked\"" : ""
    if !@checkbox_percent25.blank? ||!@checkbox_percent50.blank? || !@checkbox_percent75.blank? 
      @checkbox_percent100 = ""
    end
    @credit_card = params[:credit_card]
    
    # Create a list of credit cards with cashback percentages. Only bother to do
    # this if the current user is paying - we don't have the credit card
    # cashback information for the other user.
    # The sort order is: Default Cashback, Visit Count, Cashback Percentage
    @all_cashbacks = []
    if (@owner_paid && @obj.current_user_owns?) || (!@owner_paid && !@obj.current_user_owns?)
      @all_cashbacks = User.current_user.current_identity.credit_cards.map{|credit_card|
        credit_card.credit_card_cashbacks.map{|cc_cashback| cc_cashback.cashback}
      }.flatten.compact.reject{|cashback| cashback.expired?}.sort{|cashback1, cashback2|
        if cashback1.default_cashback && cashback2.default_cashback
          visit_count1 = cashback1.credit_card_cashback.credit_card.visit_count
          if visit_count1.nil?
            visit_count1 = 0
          end
          visit_count2 = cashback2.credit_card_cashback.credit_card.visit_count
          if visit_count2.nil?
            visit_count2 = 0
          end
          if visit_count1 == visit_count2
            cashback2.cashback_percentage <=> cashback1.cashback_percentage
          else
            visit_count2 <=> visit_count1
          end
        elsif cashback1.default_cashback
          -1
        elsif cashback2.default_cashback
          1
        else
          cashback2.cashback_percentage <=> cashback1.cashback_percentage
        end
      }.map do |cashback|
        [
          cashback.credit_card_cashback.credit_card.display(false) + " - " + cashback.cashback_percentage.to_s + "%" + (cashback.applies_to.blank? ? "" :  " (" + cashback.applies_to + ")"),
          cashback.cashback_percentage.to_s
        ]
      end
    end
    
    if request.patch?
      Rails.logger.debug{"Adding money balance item"}
      if do_update(check_double_post: true)
        Rails.logger.debug{"do_update returned true"}
        if !@new_item.nil?
          Rails.logger.debug{"new_item: #{@new_item}, obj #{@obj.inspect}"}
          if @new_item.current_user_owns?
            to = @obj.contact
            reply_to = @obj.identity.user.email
          else
            to = @obj.identity
            reply_to = @obj.contact.contact_identity.one_email
          end
          body = @obj.independent_description
          if !@new_item.money_balance_item_name.blank?
            body = @new_item.money_balance_item_name + "... \n\n" + body
          end
          to.send_email(@new_item.independent_description(false), body, nil, nil, nil, reply_to)
        end
        return after_update_redirect
      end
    end
  end
  
  def redirect_to_obj
    if !@new_item.nil?
      redirect_to obj_path,
        :flash => { :notice =>
                    @new_item.independent_description(false)
                  }
    else
      redirect_to obj_path
    end
  end

  def do_update_before_save
    i = @obj.money_balance_items.to_a.index{|mbi| mbi.new_record?}
    if !i.nil?
      @new_item = @obj.money_balance_items[i]
    end
  end

  def who_paid_title(owner_paid)
    MoneyBalancesController.who_paid_title(@obj, owner_paid)
  end
  
  def self.who_paid_title(obj, owner_paid)
    if owner_paid
      if obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.i_paid")
      else
        I18n.t("myplaceonline.money_balances.other_paid", { other: obj.identity.display })
      end
    else
      if obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.other_paid", { other: obj.contact.display(simple: true) })
      else
        I18n.t("myplaceonline.money_balances.i_paid")
      end
    end
  end
  
  def other_owed_name(owner_paid)
    MoneyBalancesController.other_owed_name(@obj, owner_paid)
  end

  def self.other_owed_name(obj, owner_paid)
    if owner_paid
      if obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.x_owes", { x: obj.contact.display(simple: true) })
      else
        I18n.t("myplaceonline.money_balances.i_owe")
      end
    else
      if obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.i_owe")
      else
        I18n.t("myplaceonline.money_balances.x_owes", { x: obj.identity.display })
      end
    end
  end

  def other_display
    if @obj.current_user_owns?
      @obj.contact.display(simple: true)
    else
      @obj.identity.display
    end
  end

  def show_add
    false
  end

  def share_permissions
    [Permission::ACTION_READ, Permission::ACTION_UPDATE]
  end

  def footer_items_show
    [
      {
        title: I18n.t('myplaceonline.money_balances.i_paid'),
        link: money_balance_add_path(@obj, owner_paid: @obj.current_user_owns? ? "true" : "false"),
        icon: "eye"
      },
      {
        title: I18n.t('myplaceonline.money_balances.other_paid', { other: self.other_display }),
        link: money_balance_add_path(@obj, owner_paid: @obj.current_user_owns? ? "false" : "true"),
        icon: "user"
      },
      {
        title: I18n.t('myplaceonline.money_balances.money_balance_items'),
        link: money_balance_money_balance_items_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t('myplaceonline.money_balances.templates'),
        link: money_balance_money_balance_item_templates_path(@obj),
        icon: "recycle"
      }
    ] + super
  end
  
  protected
    def obj_params
      params.require(:money_balance).permit(
        MoneyBalancesController.param_names
      )
    end
end
