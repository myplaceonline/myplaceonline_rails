class PeriodicPayment < MyplaceonlineIdentityRecord
  validates :periodic_payment_name, presence: true
  
  def display
    result = periodic_payment_name
    if !payment_amount.nil?
      result += " (" + Myp.number_to_currency(payment_amount)
      if !date_period.nil?
        result += " " + Myp.get_select_name(date_period, Myp::PERIODS)
      end
      if date_period == 1
        result += ", " + Myp.number_to_currency(payment_amount / 12) + " " + Myp.get_select_name(0, Myp::PERIODS)
      elsif date_period == 2
        result += ", " + Myp.number_to_currency(payment_amount / 6) + " " + Myp.get_select_name(0, Myp::PERIODS)
      end
      result += ")"
      if !ended.nil? && Date.today > ended
        result += " (Ended " + Myp.display_date_short(ended, User.current_user) + ")"
      end
    end
    result
  end

  after_save { |x| DueItem.due_periodic_payments(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |x| DueItem.due_periodic_payments(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
