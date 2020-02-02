class JobSalary < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :job
  
  validates :started, presence: true
  validates :salary, presence: true
  validates :salary_period, presence: true

  def display
    display_amount = 
    if !self.job.work_time_percentage.nil?
    end
    
    if self.job.work_time_percentage.nil?
      Myp.appendstrwrap(Myp.number_to_currency(self.yearly_salary) + " " + I18n.t("myplaceonline.periods.yearly"), self.new_title)
    else
      Myp.appendstrwrap(Myp.number_to_currency((self.yearly_salary*(self.job.work_time_percentage/100.0))) + " " + I18n.t("myplaceonline.periods.yearly"), self.new_title) + " (#{Myp.number_to_currency(self.yearly_salary)} @ #{self.job.work_time_percentage}%)"
    end
  end
  
  def process_display(amount)
    if self.job.work_time_percentage.nil?
      return Myp.number_to_currency(amount)
    else
      return Myp.appendstrwrap(Myp.number_to_currency((amount*(self.job.work_time_percentage/100.0))), "#{Myp.number_to_currency(amount)} @ #{self.job.work_time_percentage}%")
    end
  end
  
  def yearly_salary
    result = nil
    if !self.salary_period.nil?
      if self.salary_period == 0
        result = self.salary * 12
      elsif self.salary_period == 1
        result = self.salary
      else
        raise "TODO"
      end
    end
    result
  end
  
  def yearly_salary_display
    return self.process_display(self.yearly_salary)
  end
  
  def get_hours_per_week
    # Average hours worked per week
    ahwpw = self.hours_per_week
    
    if ahwpw.nil?
      ahwpw = self.job.hours_per_week
    end
    
    if ahwpw.nil?
      # Average days worked per week
      adwpw = 5.0
      
      # Average number of hours per day
      anhpd = 8.0
      
      ahwpw = adwpw * anhpd
    end
    
    ahwpw
  end
  
  def yearly_hourly
    result = nil
    if !self.salary_period.nil?
      if self.salary_period == 0
        # Average number of weeks in a month
        anwm = 52.0 / 12.0
        
        # Average number of hours per month
        anhpm = get_hours_per_week * anwm
        
        result = self.salary / anhpm
      elsif self.salary_period == 1
        # Average number of weeks in a year
        anwy = 52.0
        
        # Average number of hours per year
        anhpy = get_hours_per_week * anwy
        
        result = self.salary / anhpy
      else
        raise "TODO"
      end
    end
    result
  end
  
  def yearly_hourly_display
    return self.process_display(self.yearly_hourly)
  end

  def yearly_monthly
    return self.yearly_salary / 12
  end
  
  def yearly_monthly_display
    return self.process_display(self.yearly_monthly)
  end
end
