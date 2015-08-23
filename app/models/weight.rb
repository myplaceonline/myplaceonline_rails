class Weight < MyplaceonlineIdentityRecord
  validates :amount, presence: true
  validates :amount_type, presence: true
  validates :measure_date, presence: true
  
  def display
    result = amount.to_s
    if amount_type == 0
      result += " lb"
    end
    result += " (" + Myp.display_date(measure_date, User.current_user) + ")"
    result
  end
    
  def self.build(params = nil)
    result = super(params)
    result.amount_type = 0
    result.measure_date = Date.today
    result
  end
end
