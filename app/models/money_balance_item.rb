class MoneyBalanceItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :money_balance

  validates :money_balance_item_name, presence: true
  validates :amount, presence: true
  validates :item_time, presence: true
end
