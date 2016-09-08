class Bet < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :bet_name, presence: true
  validates :bet_amount, presence: true
  
  has_many :bet_contacts, :dependent => :destroy
  accepts_nested_attributes_for :bet_contacts, allow_destroy: true, reject_if: :all_blank

  def display
    Myp.appendstrwrap(bet_name, Myp.display_date_short_year(bet_end_date, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.bet_start_date = User.current_user.date_now
    result.odds_direction_owner = true
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
    if MyplaceonlineExecutionContext.handle_updates?
      Email.send_emails_to_contacts_and_groups_by_properties(
        I18n.t("myplaceonline.bets.bet_" + (create ? "created" : "updated") + "_subject"),
        I18n.t(
          "myplaceonline.bets.bet_" + (create ? "created" : "updated"),
          owner: identity.display_short,
          bet_name: bet_name,
          amount: Myp.number_to_currency(bet_amount),
          odds_ratio: Myp.blank_fallback(odds_ratio, 1),
          favor_order: I18n.t(
            "myplaceonline.bets." + (odds_direction_owner ? "favor_order_owner" : "favor_order_other"),
            owner: identity.display_short
          ),
          end_date: Myp.blank_fallback(Myp.display_date_short_year(bet_end_date, User.current_user), I18n.t("myplaceonline.bets.unspecified_end_date")),
          conditions: Myp.blank_fallback(notes, I18n.t("myplaceonline.bets.no_conditions"))
        ),
        self,
        "bet_contacts",
        nil
      )
    end
  end
end
