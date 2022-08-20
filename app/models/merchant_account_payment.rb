class MerchantAccountPayment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :payment_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :amount_per_payment, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :percent_total, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :merchant_account

  validates :payment_name, presence: true

  def display
    payment_name
  end

  def self.params
    [
      :id,
      :_destroy,
      :payment_name,
      :amount_per_payment,
      :percent_total,
      :notes,
    ]
  end
end
