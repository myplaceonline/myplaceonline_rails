class MoneyBalanceItemsController < MyplaceonlineController
  def path_name
    "money_balance_money_balance_item"
  end

  def form_path
    "money_balance_items/form"
  end
  
  def allow_add
    false
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.money_balance_items.money_balance'),
        link: money_balance_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.money_balance_items.money_balance'),
        link: money_balance_path(@obj.money_balance),
        icon: "back"
      }
    ]
  end
  
  def display_obj(obj)
    obj.display_initials
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.money_balance_items.item_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["money_balance_items.item_time"]
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
    
    def additional_items?
      false
    end

    def parent_model
      MoneyBalance
    end

    def find_explicit_items
      if !Permission.where(
          "user_id = ? and subject_class = ? and subject_id = ? and (action & #{Permission::ACTION_MANAGE} != 0 or action & #{Permission::ACTION_READ} != 0)",
          current_user.id,
          MoneyBalance.name.underscore.pluralize,
          @parent.id
        ).first.nil?
        MoneyBalanceItem.where(money_balance_id: @parent.id).to_a.map{|x| x.id}
      else
        nil
      end
    end
end
