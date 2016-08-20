class MoneyBalanceItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :money_balance

  validates :amount, presence: true
  #validates :money_balance_item_name, presence: true
  validates :item_time, presence: true

  attr_accessor :invert
  
  def display
    independent_description
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
  
  def independent_description(withtime = true)
    name = withtime ? "myplaceonline.money_balances.paid" : "myplaceonline.money_balances.paid_notime"
    if amount < 0
      I18n.t(name, {
          x: money_balance.contact.display,
          y: money_balance.identity.display,
          amount: Myp.number_to_currency(amount.abs),
          time: item_time
        }
      )
    else
      I18n.t(name, {
          x: money_balance.identity.display,
          y: money_balance.contact.display,
          amount: Myp.number_to_currency(amount),
          time: item_time
        }
      )
    end
  end

  def final_search_result
    money_balance
  end
end
