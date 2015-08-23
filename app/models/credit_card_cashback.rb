class CreditCardCashback < MyplaceonlineIdentityRecord
  belongs_to :credit_card
  belongs_to :cashback, :dependent => :destroy
  accepts_nested_attributes_for :cashback, allow_destroy: true, reject_if: :all_blank
  
  def expiration_includes_today?
    Myp.includes_today?(cashback.start_date, cashback.end_date)
  end
end
