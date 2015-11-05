class CreditCardsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:listcashback, :total_credit]

  def index
    @defunct = params[:defunct]
    if !@defunct.blank?
      @defunct = @defunct.to_bool
    end
    super
  end

  def listcashback
    @cashbacks = CreditCardCashback.where(owner_id: current_user.primary_identity.id).sort{ |x, y| y.cashback.cashback_percentage <=> x.cashback.cashback_percentage }.keep_if{|c| c.expiration_includes_today?}
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

  protected
    def sorts
      ["lower(credit_cards.name) ASC"]
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
        :is_defunct,
        :card_type,
        :total_credit,
        :email_reminders,
        Myp.select_or_create_permit(params[:credit_card], :password_attributes, PasswordsController.param_names),
        Myp.select_or_create_permit(params[:credit_card], :address_attributes, LocationsController.param_names),
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

    def all_additional_sql
      if @defunct.blank? || !@defunct
        "and defunct is null"
      else
        nil
      end
    end
end
