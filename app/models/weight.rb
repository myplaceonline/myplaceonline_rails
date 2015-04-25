class Weight < ActiveRecord::Base
  belongs_to :identity
  
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

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
