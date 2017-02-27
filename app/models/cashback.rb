class Cashback < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :cashback_percentage, presence: true

  has_one :credit_card_cashback
  
  def expired?
    if !end_date.nil? && end_date <= Date.today
      true
    else
      false
    end
  end

  def self.params
    [
      :id,
      :cashback_percentage,
      :applies_to,
      :start_date,
      :end_date,
      :yearly_maximum,
      :notes,
      :default_cashback
    ]
  end
  
  def final_search_result
    credit_card_cashback.credit_card
  end
end
