class MoneyBalanceItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern

  belongs_to :money_balance

  validates :amount, presence: true
  #validates :money_balance_item_name, presence: true
  validates :item_time, presence: true
  
  humanized_float_accessor :original_amount

  attr_accessor :invert
  
  def display
    Myp.appendstrwrap(independent_description, Myp.ellipses_if_needed(self.money_balance_item_name, 16))
  end

  def display_initials
    name = "myplaceonline.money_balances.money_item_display"
    i18n_data = {}
    if !self.original_amount.nil? && self.original_amount != self.amount
      name << "_with_original"
      i18n_data[:original_amount] = Myp.number_to_currency(self.original_amount.abs)
    end
    if !self.money_balance_item_name.blank?
      i18n_data.merge!({
        description: Myp.ellipses_if_needed(self.money_balance_item_name, 16)
      })
    else
      name << "_nofor"
    end
    i18n_data.merge!({
      x: amount < 0 ? money_balance.contact.display_initials : money_balance.identity.display_initials,
      amount: Myp.number_to_currency(amount.abs),
      time: Myp.display_time(item_time, User.current_user, :super_short_datetime_year),
    })
    I18n.t(name, i18n_data)
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
    i18n_data = {}
    if !self.original_amount.nil? && self.original_amount != self.amount
      name << "_with_original"
      i18n_data[:original_amount] = Myp.number_to_currency(self.original_amount.abs)
    end
    if amount < 0
      i18n_data.merge!({
        x: initials ? money_balance.contact.display_initials : money_balance.contact.display(simple: true),
        y: initials ? money_balance.identity.display_initials : money_balance.identity.display,
        amount: Myp.number_to_currency(amount.abs),
        time: item_time
      })
    else
      i18n_data.merge!({
        x: initials ? money_balance.identity.display_initials : money_balance.identity.display,
        y: initials ? money_balance.contact.display_initials : money_balance.contact.display(simple: true),
        amount: Myp.number_to_currency(amount),
        time: item_time
      })
    end
    I18n.t(name, i18n_data)
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
