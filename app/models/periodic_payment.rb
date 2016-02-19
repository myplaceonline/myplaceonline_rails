class PeriodicPayment < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS = 3.days
  DEFAULT_PERIODIC_PAYMENT_AFTER_THRESHOLD_SECONDS = 3.days

  validates :periodic_payment_name, presence: true
  
  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
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

  def next_payment
    result = nil
    today = Date.today
    if !started.nil?
      result = started
    elsif date_period == 0
      result = Date.new(today.year, today.month)
    elsif date_period == 1 || date_period == 2
      result = Date.new(today.year)
    end
    if !result.nil?
      while result < today
        if date_period == 0
          result = result.advance(months: 1)
        elsif date_period == 1
          result = result.advance(years: 1)
        elsif date_period == 2
          result = result.advance(months: 6)
        end
      end
    end
    result
  end
  
  def self.calendar_item_display(calendar_item)
    periodic_payment = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.periodic_payments.reminder_before",
      name: periodic_payment.display,
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ActiveRecord::Base.transaction do
      on_after_destroy
      if !suppress_reminder && !next_payment.nil?
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            next_payment,
            (calendar.periodic_payment_before_threshold_seconds || DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id,
            repeat_amount: 1,
            repeat_type: Myp.period_to_repeat_type(date_period)
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.primary_identity,
      self.class,
      model_id: id
    )
  end
end
