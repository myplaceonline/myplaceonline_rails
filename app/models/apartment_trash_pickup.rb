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
    if period_type >= 3 && period_type <= 9
      cwday = period_type - 2
      result = Date.new(today.year, today.month)
      while true
        if result.cwday == cwday
          result += ((period - 1) * 7).day
          break
        end
        result += 1.day
      end
      if result < today
        next_month = Date.new(today.year, today.month) + 6.weeks
        result = Date.new(next_month.year, next_month.month)
        while true
          if result.cwday == cwday
            result += ((period - 1) * 7).day
            break
          end
          result += 1.day
        end
      end
    else
      while result < today
        if period_type == 0
          result = result.advance(days: period)
        elsif period_type == 1
          result = result.advance(weeks: period)
        elsif period_type == 2
          result = result.advance(weeks: 4*period)
        end
      end
    end
    result
  end

  after_save { |record| DueItem.due_apartments(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_apartments(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
