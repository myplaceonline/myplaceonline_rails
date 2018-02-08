class BetsController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.bet_amount_with_currency(append_ratio: true)
  end

  def update_status
    set_obj
    new_status = Myp.param_integer(params, :status)
    if new_status == Bet::BET_STATUS_NOBODY_WON || new_status == Bet::BET_STATUS_I_WON_PAID || new_status == Bet::BET_STATUS_OTHER_WON_PAID
      @obj.archived = Time.now
    else
      @obj.archived = nil
    end
    @obj.bet_status = new_status
    @obj.save!
    redirect_to obj_path,
      :flash => { :notice => I18n.t("myplaceonline.bets.status_updated") }
  end
  
  def footer_items_show
    
    result = super

    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.bets.bet_statuses.i_won_not_paid"),
        link: bet_update_status_path(@obj, status: Bet::BET_STATUS_I_WON_NOT_PAID.to_s),
        icon: "eye"
      }
      
      result << {
        title: I18n.t("myplaceonline.bets.bet_statuses.i_won_paid"),
        link: bet_update_status_path(@obj, status: Bet::BET_STATUS_I_WON_PAID.to_s),
        icon: "eye"
      }
      
      result << {
        title: I18n.t("myplaceonline.bets.bet_statuses.other_won_not_paid"),
        link: bet_update_status_path(@obj, status: Bet::BET_STATUS_OTHER_WON_NOT_PAID.to_s),
        icon: "user"
      }
      
      result << {
        title: I18n.t("myplaceonline.bets.bet_statuses.other_won_paid"),
        link: bet_update_status_path(@obj, status: Bet::BET_STATUS_OTHER_WON_PAID.to_s),
        icon: "user"
      }
    end
    
    result
    
  end

  def show_created_updated
    true
  end
  
  protected
    def default_sort_columns
      ["bets.bet_end_date"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.bets.bet_end_date"), default_sort_columns[0]]
      ]
    end

    def default_sorts_additions
      "nulls first"
    end

    def default_sort_direction
      "desc"
    end

    def obj_params
      params.require(:bet).permit(
        :bet_name,
        :notes,
        :bet_start_date,
        :bet_end_date,
        :bet_amount,
        :odds_ratio,
        :odds_direction_owner,
        :bet_currency,
        :bet_status,
        bet_contacts_attributes: [
          :id,
          :_destroy,
          contact_attributes: ContactsController.param_names
        ]
      )
    end
end
