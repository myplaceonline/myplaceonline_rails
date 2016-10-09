class JobSalary < ActiveRecord::Base
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
      else
        raise "TODO"
      end
    end
    result
  end
  
  def yearly_hourly
    result = nil
    if !self.salary_period.nil?
      if self.salary_period == 0
        # Average number of weeks in a month
        anwm = 52.0 / 12.0
        
        # Average days worked per week
        adwpw = 5.0
        
        # Average number of hours per day
        anhpd = 8.0
        
        # Average number of hours per month
        anhpm = anhpd * adwpw * anwm
        
        result = self.salary / anhpm
      else
        raise "TODO"
      end
    end
    result
  end
end
