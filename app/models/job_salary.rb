class JobSalary < ActiveRecord::Base
  belongs_to :owner, class: Identity
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

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
