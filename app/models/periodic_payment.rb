class PeriodicPayment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern

  DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS = 3.days
  DEFAULT_PERIODIC_PAYMENT_AFTER_THRESHOLD_SECONDS = 3.days

  validates :periodic_payment_name, presence: true
  
  child_property(name: :password)
  
  child_files

  def display
    result = periodic_payment_name
    if !payment_amount.nil?
      result += " ("
      
      if !date_period.nil?
        
        # Always show monthly first for easier side-by-side comparison
        if date_period == Myp::PERIOD_MONTHLY
          result += Myp.number_to_currency(payment_amount) + " " + Myp.get_select_name(Myp::PERIOD_MONTHLY, Myp::PERIODS)
        elsif date_period == Myp::PERIOD_YEARLY
          result += Myp.number_to_currency(payment_amount / 12.0) + " " + Myp.get_select_name(Myp::PERIOD_MONTHLY, Myp::PERIODS)
        elsif date_period == Myp::PERIOD_SIX_MONTHS
          result += Myp.number_to_currency(payment_amount / 6.0) + " " + Myp.get_select_name(Myp::PERIOD_MONTHLY, Myp::PERIODS)
        else
          raise "TODO"
        end
        
        # For non-monthly, also show the original amount
        if date_period != Myp::PERIOD_MONTHLY
          result += "; " + Myp.number_to_currency(payment_amount) + " " + Myp.get_select_name(date_period, Myp::PERIODS)
        end
      else
        result += Myp.number_to_currency(payment_amount)
      end
      
      result += ")"
      
      if !ended.nil? && Date.today > ended
        result += " (Ended " + Myp.display_date_short(ended, User.current_user) + ")"
      end
    end
    if !archived.nil?
      result += " (" + I18n.t("myplaceonline.general.archived") + ")"
    end
    result
  end

  def next_payment
    result = nil
    if !date_period.nil?
      today = Date.today
      if !started.nil?
        result = started
      elsif date_period == Myp::PERIOD_MONTHLY
        result = Date.new(today.year, today.month)
      elsif date_period == Myp::PERIOD_YEARLY || date_period == Myp::PERIOD_SIX_MONTHS
        result = Date.new(today.year)
      end
      if !result.nil?
        while result < today
            if date_period == Myp::PERIOD_MONTHLY
            result = result.advance(months: 1)
            elsif date_period == Myp::PERIOD_YEARLY
            result = result.advance(years: 1)
            elsif date_period == Myp::PERIOD_SIX_MONTHS
            result = result.advance(months: 6)
            end
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
    if MyplaceonlineExecutionContext.handle_updates?
      ApplicationRecord.transaction do
        on_after_destroy
        if !suppress_reminder && !next_payment.nil? && !self.is_archived?
          
          Rails.logger.debug{"PeriodicPayment.on_after_save identity: #{User.current_user.current_identity_id}, next_payment: #{next_payment}, model_id: #{self.id}"}
          
          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: next_payment,
              reminder_threshold_amount: (calendar.periodic_payment_before_threshold_seconds || DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id,
              repeat_amount: 1,
              repeat_type: Myp.period_to_repeat_type(date_period),
              max_pending: 1
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.current_identity,
      self.class,
      model_id: id
    )
  end

  def self.skip_check_attributes
    ["suppress_reminder"]
  end

  child_properties(name: :periodic_payment_instances, sort: "payment_date DESC")
end
