class Repeat < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :start_date, presence: true
  validates :period_type, presence: true
  validates :period, presence: true

  def next_instance
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

  def self.params
    [
      :id,
      :start_date,
      :period_type,
      :period
    ]
  end
end
