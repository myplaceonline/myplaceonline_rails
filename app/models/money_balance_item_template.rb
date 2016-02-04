class MoneyBalanceItemTemplate < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :money_balance
  
  validates :amount, presence: true
  validates :money_balance_item_name, presence: true
  
  def display
    money_balance_item_name
  end
end
