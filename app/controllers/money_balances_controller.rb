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
        :notes
      ]
    ]
  end
  
  def list
    set_obj
  end
  
  def add
    Myp.ensure_encryption_key(session)
    set_obj
    # X paid a bill and Y either owes 100%, 50%, or some other percent
    owner_paid_str = params[:owner_paid].blank? ? "true" : params[:owner_paid]
    @owner_paid = owner_paid_str.to_bool
    @amount = params[:amount]
    @original_amount = params[:original_amount]
    @description = params[:description]
    @checkbox_percent50 = " checked=\"checked\""
    @checkbox_percent100 = params[:percent_default] == "1.0" ? " checked=\"checked\"" : ""
    if !@checkbox_percent100.blank?
      @checkbox_percent50 = ""
    end
    if request.patch?
      Rails.logger.debug{"Adding money balance item"}
      if do_update(check_double_post: true)
        Rails.logger.debug{"do_update returned true"}
        if !@new_item.nil?
          Rails.logger.debug{"new_item: #{@new_item}"}
          if @new_item.current_user_owns?
            to = @obj.contact
          else
            to = @obj.identity.ensure_contact!
          end
          body = @obj.independent_description
          if !@new_item.money_balance_item_name.blank?
            body = @new_item.money_balance_item_name + "... \n\n" + body
          end
          to.send_email(@new_item.independent_description(false), body)
        end
        return after_create_or_update
      end
    end
  end
  
  def do_update_before_save
    i = @obj.money_balance_items.index{|mbi| mbi.new_record?}
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
        I18n.t("myplaceonline.money_balances.other_paid", { other: obj.contact.display })
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
        I18n.t("myplaceonline.money_balances.x_owes", { x: obj.contact.display })
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
      @obj.contact.display
    else
      @obj.identity.display
    end
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
  
  def show_add
    false
  end

  protected
    def sorts
      ["money_balances.updated_at DESC"]
    end

    def obj_params
      params.require(:money_balance).permit(
        MoneyBalancesController.param_names
      )
    end
end
