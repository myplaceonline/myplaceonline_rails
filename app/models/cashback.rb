class Cashback < MyplaceonlineIdentityRecord
  validates :cashback_percentage, presence: true

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
end
