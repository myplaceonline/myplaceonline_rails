class Height < ActiveRecord::Base
  belongs_to :identity

  validates :height_amount, presence: true
  validates :amount_type, presence: true
  validates :measurement_date, presence: true
  
  def display
    result = height_amount.to_s
    if amount_type == 0
      result += " inches"
    end
    result += " (" + Myp.display_date(measurement_date, User.current_user) + ")"
    result
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
