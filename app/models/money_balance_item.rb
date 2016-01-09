class MoneyBalanceItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :money_balance

  validates :amount, presence: true
  #validates :money_balance_item_name, presence: true
  validates :item_time, presence: true

  attr_accessor :invert

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.item_time = Time.now
    result
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
