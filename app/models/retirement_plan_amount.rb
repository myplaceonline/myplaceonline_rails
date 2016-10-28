class RetirementPlanAmount < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :retirement_plan
  validates :input_date, presence: true
  validates :amount, presence: true
  
  def display
    Myp.appendstrwrap(Myp.display_currency(amount, User.current_user), Myp.display_date(input_date, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.input_date = User.current_user.date_now
    result
  end
end
