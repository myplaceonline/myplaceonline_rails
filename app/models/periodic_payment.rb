class PeriodicPayment < ActiveRecord::Base
  belongs_to :identity
  validates :periodic_payment_name, presence: true
  
  def display
    result = periodic_payment_name
    if !payment_amount.nil?
      result += " (" + payment_amount.to_s
      if !date_period.nil?
        result += " " + Myp.get_select_name(date_period, Myp::PERIODS)
      end
      result += ")"
      if !ended.nil? && Date.today > ended
        result += " (Ended " + Myp.display_date_short(ended, current_user) + ")"
      end
    end
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
