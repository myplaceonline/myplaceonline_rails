class CreditCardsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:listcashback, :total_credit, :main]

  def listcashback
    @cashbacks = CreditCardCashback.where(identity_id: current_user.primary_identity.id).sort{ |x, y| y.cashback.cashback_percentage <=> x.cashback.cashback_percentage }.keep_if{|c| c.expiration_includes_today?}
  end

  def total_credit
    @total_credit = 0
    all.each do |cc|
      if !cc.total_credit.nil? && !cc.is_expired
        @total_credit += cc.total_credit
      end
    end
  end

  def cashback_for(cb)
    if cb.cashback.applies_to.blank?
      ""
    else
      I18n.t("myplaceonline.general.for") + " " + cb.cashback.applies_to + " "
    end
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.credit_cards.list_cashbacks'),
        link: credit_cards_listcashback_path,
        icon: "bullets"
      },
      {
        title: I18n.t('myplaceonline.credit_cards.total_credit'),
        link: credit_cards_total_credit_path,
        icon: "info"
      }
    ]
  end
  
  def may_upload
    true
  end

  def main
    redirect_to(credit_card_path(self.all.order("visit_count DESC").limit(1).take!))
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.credit_cards.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(credit_cards.name)"]
    end

    def obj_params
      params.require(:credit_card).permit(
        :name,
        :number,
        :expires,
        :security_code,
        :pin,
        :notes,
        :encrypt,
        :card_type,
        :total_credit,
        :email_reminders,
        :start_date,
        password_attributes: PasswordsController.param_names,
        address_attributes: LocationsController.param_names,
        credit_card_files_attributes: FilesController.multi_param_names,
        credit_card_cashbacks_attributes: [
          :id,
          :_destroy,
          cashback_attributes: Cashback.params
        ]
      )
    end
    
    def sensitive
      true
    end
end
