class MoneyBalanceItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :money_balance

  validates :amount, presence: true
  #validates :money_balance_item_name, presence: true
  validates :item_time, presence: true

  attr_accessor :invert
  
  def display
    Myp.appendstrwrap(independent_description, Myp.ellipses_if_needed(self.money_balance_item_name, 16))
  end

  def display_initials
    I18n.t("myplaceonline.money_balances.money_item_display", {
        x: amount < 0 ? money_balance.contact.display_initials : money_balance.identity.display_initials,
        amount: Myp.number_to_currency(amount.abs),
        time: Myp.display_time(item_time, User.current_user, :super_short_datetime_year),
        description: Myp.ellipses_if_needed(self.money_balance_item_name, 16)
      }
    )
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.item_time = Time.now
    result
  end

  validate do
    if !self.amount.nil?
      if !invert.blank?
        if invert.to_bool
          self.amount = self.amount.abs * -1
          if !self.original_amount.blank?
            self.original_amount = self.original_amount.abs * -1
          end
        else
          self.amount = self.amount.abs
          if !self.original_amount.blank?
            self.original_amount = self.original_amount.abs
          end
        end
      end
    end
  end
  
  def independent_description(withtime = true, initials: false)
    name = withtime ? "myplaceonline.money_balances.paid" : "myplaceonline.money_balances.paid_notime"
    if amount < 0
      I18n.t(name, {
          x: initials ? money_balance.contact.display_initials : money_balance.contact.display,
          y: initials ? money_balance.identity.display_initials : money_balance.identity.display,
          amount: Myp.number_to_currency(amount.abs),
          time: item_time
        }
      )
    else
      I18n.t(name, {
          x: initials ? money_balance.identity.display_initials : money_balance.identity.display,
          y: initials ? money_balance.contact.display_initials : money_balance.contact.display,
          amount: Myp.number_to_currency(amount),
          time: item_time
        }
      )
    end
  end

  def final_search_result
    money_balance
  end

  after_commit :on_after_update, on: :update
  
  def on_after_update
    if MyplaceonlineExecutionContext.handle_updates?
      message = display
      if !self.money_balance_item_name.blank?
        message += "\n\n" + self.money_balance_item_name
      end
      if !self.notes.blank?
        message += "\n\n" + self.notes
      end
      money_balance.send_email_to_all(
        I18n.t(
          "myplaceonline.money_balance_items.item_updated_subject"
        ),
        I18n.t(
          "myplaceonline.money_balance_items.item_updated_body",
          display: message
        )
      )
    end
  end

  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    message = display
    if !self.money_balance_item_name.blank?
      message += "\n\n" + self.money_balance_item_name
    end
    if !self.notes.blank?
      message += "\n\n" + self.notes
    end
    money_balance.send_email_to_all(
      I18n.t(
        "myplaceonline.money_balance_items.item_destroyed_subject"
      ),
      I18n.t(
        "myplaceonline.money_balance_items.item_destroyed_body",
        display: message
      )
    )
  end
  
  def permission_check_target
    self.money_balance
  end
end
