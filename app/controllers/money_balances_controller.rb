class MoneyBalancesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:add, :list]

  def self.param_names(params)
    [
      Myp.select_or_create_permit(params, :contact_attributes, ContactsController.param_names),
      :notes,
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
    set_obj
    # X paid a bill and Y either owes 100%, 50%, or some other percent
    @owner_paid = params[:owner_paid].to_bool
    if request.patch?
      if do_update
        if !@new_item.nil?
          if @new_item.current_user_owns?
            to = @obj.contact
          else
            to = @obj.identity.ensure_contact!
          end
          to.send_email(@new_item.independent_description(false), @obj.independent_description, User.current_user.primary_identity.emails)
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
    if owner_paid
      if @obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.i_paid")
      else
        I18n.t("myplaceonline.money_balances.other_paid", { other: @obj.identity.display })
      end
    else
      if @obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.other_paid", { other: @obj.contact.display })
      else
        I18n.t("myplaceonline.money_balances.i_paid")
      end
    end
  end
  
  def other_owed_name(owner_paid)
    if owner_paid
      if @obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.x_owes", { x: @obj.contact.display })
      else
        I18n.t("myplaceonline.money_balances.i_owe")
      end
    else
      if @obj.current_user_owns?
        I18n.t("myplaceonline.money_balances.i_owe")
      else
        I18n.t("myplaceonline.money_balances.x_owes", { x: @obj.identity.display })
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
