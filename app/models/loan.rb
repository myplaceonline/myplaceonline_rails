class Loan < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

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
