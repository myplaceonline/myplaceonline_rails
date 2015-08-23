class Loan < MyplaceonlineIdentityRecord
  validates :lender, presence: true

  def self.params
    [
      :id,
      :lender,
      :amount,
      :start,
      :paid_off,
      :monthly_payment,
    ]
  end
end
