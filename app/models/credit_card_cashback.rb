class CreditCardCashback < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :credit_card

  child_property(name: :cashback)
  
  def expiration_includes_today?
    Myp.includes_today?(cashback.start_date, cashback.end_date)
  end

  def self.skip_check_attributes
    ["default_cashback"]
  end
end
