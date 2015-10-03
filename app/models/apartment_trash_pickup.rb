class ApartmentTrashPickup < MyplaceonlineIdentityRecord
  TRASH_TYPES = [
    ["myplaceonline.trash.type_general", 0],
    ["myplaceonline.trash.type_recycling", 1]
  ]
  
  belongs_to :apartment

  validates :trash_type, presence: true
  validates :start_date, presence: true
  validates :period_type, presence: true
  validates :period, presence: true
  
  def next_pickup
    # Start at the start date, and keep adding the period until we're >= today
    result = start_date
    today = Date.today
    while result < today
      if period_type == 0
        result = result.advance(days: period)
      elsif period_type == 1
        result = result.advance(weeks: period)
      else
        result = result.advance(weeks: 4*period)
      end
    end
    result
  end
end
