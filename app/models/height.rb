class Height < ActiveRecord::Base
  belongs_to :owner, class: Identity

  validates :height_amount, presence: true
  validates :amount_type, presence: true
  validates :measurement_date, presence: true
  
  def display
    result = ""
    if amount_type == 0
      result += (height_amount / 12).floor.to_s + " feet"
      inches = (height_amount % 12)
      inches = (inches * 10**2).round.to_f / 10**2
      if inches > 0
        result += ", " + inches.to_s.gsub("\.0", "") + " inches"
      end
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
