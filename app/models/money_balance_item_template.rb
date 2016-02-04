class MoneyBalanceItemTemplate < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :money_balance
  
  validates :amount, presence: true
  validates :money_balance_item_name, presence: true
  
  attr_accessor :invert

  def display
    Myp.appendstrwrap(
      money_balance_item_name,
      Myp.display_currency(amount.abs)
    )
  end

  validate do
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
