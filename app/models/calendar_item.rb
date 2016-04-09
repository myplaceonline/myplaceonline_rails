class CalendarItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :calendar

  has_many :calendar_item_reminders, :dependent => :destroy
  
  def display
    if @cached_display.nil?
      model = Object.const_get(model_class)
      @cached_display = model.calendar_item_display(self)
    end
    @cached_display
  end
  
  def link
    model = Object.const_get(model_class)
    if model.respond_to?("calendar_item_link")
      model.calendar_item_link(self)
    else
      if model_id.nil?
        "/" + model_class.pluralize.underscore + "/new"
      else
        "/" + model_class.pluralize.underscore + "/" + model_id.to_s
      end
    end
  end

  def short_date
    if Date.today.year > calendar_item_time.year
      Myp.display_date_short_year(calendar_item_time, User.current_user)
    else
      Myp.display_date_short(calendar_item_time, User.current_user)
    end
  end
  
  def find_model_object
    Object.const_get(model_class).find(model_id.to_i)
  end
  
  def largest_reminder_threshold_seconds
    result = nil
    calendar_item_reminders.each do |calendar_item_reminder|
      secs = Calendar.amount_to_seconds(
        calendar_item_reminder.threshold_amount,
        calendar_item_reminder.threshold_type
      )
      if result.nil? || secs > result
        result = secs
      end
    end
    result
  end

  def self.has_persistent_calendar_item(identity, calendar, model)
    CalendarItem.where(
      identity: identity,
      calendar: calendar,
      model_class: model.name,
      persistent: true
    ).count > 0
  end
  
  def self.create_persistent_calendar_item(
    identity,
    calendar,
    model,
    model_id: nil,
    context_info: nil
  )
    ActiveRecord::Base.transaction do
      calendar_item = CalendarItem.new(
        identity: identity,
        calendar: calendar,
        persistent: true,
        model_class: model.name,
        model_id: model_id,
        context_info: context_info
      )
      
      calendar_item.save!
      
      calendar_item_reminder = CalendarItemReminder.new(
        identity: identity,
        calendar_item: calendar_item
      )
      
      calendar_item_reminder.save!
      
      # Persistent items always have a reminder pending
      
      CalendarItemReminderPending.new(
        calendar_item_reminder: calendar_item_reminder,
        calendar: calendar,
        calendar_item: calendar_item,
        identity: identity
      ).save!

      calendar_item
    end
  end
  
  def self.ensure_persistent_calendar_item(identity, calendar, model)
    if !self.has_persistent_calendar_item(identity, calendar, model)
      self.create_persistent_calendar_item(identity, calendar, model)
    end
  end
  
  # Note that the default context_info of nil means that any items with
  # a non-NULL context_info will not be destroyed
  def self.destroy_calendar_items(identity, model, model_id: nil, context_info: nil)
    CalendarItem.where(
      identity: identity,
      model_class: model.name,
      model_id: model_id,
      context_info: context_info
    ).each do |calendar_item|
      calendar_item.destroy!
    end
  end
  
  # max_pending: The maximum number of concurrently outstanding reminders for
  #              this item. This is often used with a value of 1 with a
  #              repeating item for which there should only ever be a single
  #              reminder. For example, ApartmentTrashPickup uses this so that,
  #              if the trash is scheduled to be picked up once a week, a
  #              reminder is created for every week, but if the user forgets to
  #              do the trash one week, or if they forget to complete the item,
  #              and the next week comes around, then the previous reminders
  #              are deleted.
  def self.create_calendar_item(
    identity,
    calendar,
    model,
    calendar_item_time,
    reminder_threshold_amount,
    reminder_threshold_type,
    model_id: nil,
    expire_amount: nil,
    expire_type: nil,
    repeat_amount: nil,
    repeat_type: nil,
    context_info: nil,
    max_pending: nil
  )
    ActiveRecord::Base.transaction do
      calendar_item = CalendarItem.new(
        identity: identity,
        calendar: calendar,
        model_class: model.name,
        model_id: model_id,
        calendar_item_time: calendar_item_time,
        repeat_amount: repeat_amount,
        repeat_type: repeat_type,
        context_info: context_info
      )
      
      calendar_item.save!
      
      calendar_item_reminder = CalendarItemReminder.new(
        identity: identity,
        calendar_item: calendar_item,
        threshold_amount: reminder_threshold_amount,
        threshold_type: reminder_threshold_type,
        expire_amount: expire_amount,
        expire_type: expire_type,
        max_pending: max_pending
      )
      
      calendar_item_reminder.save!
      
      CalendarItemReminder.ensure_pending(identity.user)
      
      calendar_item
    end
  end
end
