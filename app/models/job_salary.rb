class JobSalary < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :job
  
  validates :started, presence: true
  validates :salary, presence: true
  validates :salary_period, presence: true

  def display
    result = Myp.number_to_currency(salary)
    if !salary_period.nil?
      result += " " + Myp.get_select_name(salary_period, Myp::PERIODS)
    end
    result
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
end
