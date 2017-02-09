class Bet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  BET_STATUS_PENDING = 0
  BET_STATUS_NOBODY_WON = 1
  BET_STATUS_I_WON_NOT_PAID = 2
  BET_STATUS_OTHER_WON_NOT_PAID = 3
  BET_STATUS_I_WON_PAID = 4
  BET_STATUS_OTHER_WON_PAID = 5
  
  BET_STATUSES = [
    ["myplaceonline.bets.bet_statuses.pending", BET_STATUS_PENDING],
    ["myplaceonline.bets.bet_statuses.nobody_won", BET_STATUS_NOBODY_WON],
    ["myplaceonline.bets.bet_statuses.i_won_not_paid", BET_STATUS_I_WON_NOT_PAID],
    ["myplaceonline.bets.bet_statuses.other_won_not_paid", BET_STATUS_OTHER_WON_NOT_PAID],
    ["myplaceonline.bets.bet_statuses.i_won_paid", BET_STATUS_I_WON_PAID],
    ["myplaceonline.bets.bet_statuses.other_won_paid", BET_STATUS_OTHER_WON_PAID]
  ]
  
  validates :bet_name, presence: true
  validates :bet_amount, presence: true
  
  child_properties(name: :bet_contacts)

  def display
    Myp.appendstrwrap(bet_name, Myp.display_date_short_year(bet_end_date, User.current_user))
  end
  
  def delta
    Myp.time_delta(self.bet_end_date)
  end
  
  def bet_amount_with_currency
    if !self.bet_amount.blank? && !self.bet_currency.blank?
      if self.bet_amount == 1
        "#{Myp.decimal_to_s(value: self.bet_amount)} #{self.bet_currency.singularize}"
      else
        "#{Myp.decimal_to_s(value: self.bet_amount)} #{self.bet_currency}"
      end
    elsif !self.bet_amount.blank?
      Myp.decimal_to_s(value: self.bet_amount)
    elsif !self.bet_currency.blank?
      self.bet_currency
    else
      nil
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.bet_start_date = User.current_user.date_now
    result.odds_direction_owner = true
    result.bet_currency = I18n.t("myplaceonline.bets.default_currency")
    result.bet_status = BET_STATUS_PENDING
    result
  end

  after_commit :on_after_create, on: [:create]
  after_commit :on_after_update, on: [:update]
  
  def on_after_create
    on_after_create_or_update(true)
  end
  
  def on_after_update
    on_after_create_or_update(false)
  end
  
  def on_after_create_or_update(create)
    Rails.logger.debug{"Bet.on_after_create_or_update create: #{create}"}
    if MyplaceonlineExecutionContext.handle_updates?
      Rails.logger.debug{"Bet.on_after_create_or_update sending email"}
      Email.send_emails_to_contacts_and_groups_by_properties(
        I18n.t("myplaceonline.bets.bet_" + (create ? "created" : "updated") + "_subject"),
        I18n.t(
          "myplaceonline.bets.bet_" + (create ? "created" : "updated"),
          owner: identity.display_short,
          bet_name: bet_name,
          amount: bet_amount_with_currency,
          odds_ratio: Myp.blank_fallback(odds_ratio, 1),
          favor_order: I18n.t(
            "myplaceonline.bets." + (odds_direction_owner ? "favor_order_owner" : "favor_order_other"),
            owner: identity.display_short
          ),
          end_date: Myp.blank_fallback(Myp.display_date_short_year(bet_end_date, User.current_user), I18n.t("myplaceonline.bets.unspecified_end_date")),
          conditions: Myp.blank_fallback(notes, I18n.t("myplaceonline.bets.no_conditions")),
          delta: self.delta,
          bet_status: Myp.get_select_name(self.bet_status, BET_STATUSES, default_value: I18n.t("myplaceonline.bets.bet_statuses.pending"))
        ),
        self,
        "bet_contacts",
        nil
      )
    end
  end

  def self.skip_check_attributes
    ["odds_direction_owner", "bet_status"]
  end
end
