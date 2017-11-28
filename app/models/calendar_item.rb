# If a CalendarItem repeats, then there is the "primary" CalendarItem
# (is_repeat = false) and then an individual CalendarItem for each repeat
# after the original (is_repeat = true).
class CalendarItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :calendar

  child_properties(name: :calendar_item_reminders, sort: "created_at ASC")
  
  def display
    if @cached_display.nil?
      model = Object.const_get(model_class)
      @cached_display = model.calendar_item_display(self)
    end
    @cached_display
  end
  
  before_destroy :on_before_destroy
  
  def on_before_destroy
    if !self.is_repeat?
      # If this is the "primary" CalendarItem (see class description), then
      # we presume we want to delete all repeat CalendarItems
      
      CalendarItem.destroy_calendar_items(
        self.identity,
        self.find_model_class,
        model_id: self.model_id,
        context_info: self.context_info,
        skip_id: self.id,
      )
    end
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
  
  def find_model_class
    Object.const_get(model_class)
  end
  
  def find_model_object
    if !model_id.nil?
      find_model_class.find(model_id.to_i)
    else
      nil
    end
  end
  
  def model_id_valid?
    if !model_id.nil?
      find_model_class.where(id: model_id).count != 0
    else
      true
    end
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
    context_info: nil,
    expire_amount: nil,
    expire_type: nil
  )
    ApplicationRecord.transaction do
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
        calendar_item: calendar_item,
        expire_amount: expire_amount,
        expire_type: expire_type
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
  
  def self.ensure_persistent_calendar_item(
    identity,
    calendar,
    model,
    expire_amount: nil,
    expire_type: nil
  )
    if !self.has_persistent_calendar_item(identity, calendar, model)
      self.create_persistent_calendar_item(
        identity,
        calendar,
        model,
        expire_amount: expire_amount,
        expire_type: expire_type
      )
    end
  end
  
  # Note that the default context_info of nil means that any items with
  # a non-NULL context_info will not be destroyed
  def self.destroy_calendar_items(identity, model, model_id: nil, context_info: nil, skip_id: nil)
    Rails.logger.debug{"CalendarItem.destroy_calendar_items entry identity: #{identity.id}, model: #{model.name}, model_id: #{model_id}, context_info: #{context_info}, skip_id: #{skip_id}"}
    CalendarItem.where(
      identity: identity,
      model_class: model.name,
      model_id: model_id,
      context_info: context_info
    ).each do |calendar_item|
      
      if skip_id.nil? || calendar_item.id != skip_id
        Rails.logger.debug{"CalendarItem.destroy_calendar_items item #{calendar_item.inspect}"}
        calendar_item.destroy!
      end
    end
    Rails.logger.debug{"CalendarItem.destroy_calendar_items exit"}
  end
  
  def all_calendar_items(with_pending: false)
    result = CalendarItem.where(
      identity_id: self.identity_id,
      model_class: self.model_class,
      model_id: self.model_id,
      context_info: self.context_info
    ).order("calendar_item_time ASC")
    
    if with_pending
      result = result.to_a.delete_if{|x| x.calendar_item_reminders.map{|y| y.calendar_item_reminder_pendings.count }.reduce{|z1, z2| z1+z2 } == 0 }
    end
    
    result
  end
  
  def next_calendar_item
    result = CalendarItem.where(
      identity_id: self.identity_id,
      model_class: self.model_class,
      model_id: self.model_id,
      context_info: self.context_info
    ).order("calendar_item_time ASC").to_a
    
    state = 0
    i = 0
    while i < result.length
      
      pendings = result[i].calendar_item_reminders.map{|y| y.calendar_item_reminder_pendings.count }.reduce{|z1, z2| z1+z2 }
      
      case state
      when 0
        if pendings > 0
          state = 1
        end
      when 1
        if pendings == 0
          break
        end
      end
      
      i = i + 1
    end
    
    if i < result.length
      result[i]
    else
      nil
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
    identity:,
    calendar:,
    model:,
    calendar_item_time:,
    reminder_threshold_amount:,
    reminder_threshold_type:,
    model_id: nil,
    expire_amount: nil,
    expire_type: nil,
    repeat_amount: nil,
    repeat_type: nil,
    context_info: nil,
    max_pending: nil
  )
    Rails.logger.debug{"CalendarItem.create_calendar_item entry time: #{calendar_item_time}"}

    ApplicationRecord.transaction do
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
      
      Rails.logger.debug{"CalendarItem.create_calendar_item new item: #{calendar_item}"}
      
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
      
      Rails.logger.debug{"CalendarItem.create_calendar_item new reminder: #{calendar_item_reminder}"}
      
      CalendarItemReminder.schedule_ensure_pending(identity.user)
      
      calendar_item
    end
  end

  def final_search_result
    calendar
  end
  
  def show_highly_visited?
    false
  end
end
