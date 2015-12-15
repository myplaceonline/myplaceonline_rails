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
end
