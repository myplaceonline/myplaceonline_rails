class PerishableFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_PERISHABLE_FOODS_THRESHOLD_SECONDS = 30.days.seconds

  child_property(name: :food, required: true)
  
  def display
    quantity_display = nil
    if !self.quantity.nil? && self.quantity > 0
      quantity_display = "x" + self.quantity.to_s
    end
    Myp.appendstr(Myp.appendstrwrap(food.display, Myp.ellipses_if_needed(self.storage_location, 16)), quantity_display)
  end

  def self.calendar_item_display(calendar_item)
    x = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.perishable_foods.expiring",
      name: x.food.display,
      delta: Myp.time_delta(x.expires)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      ApplicationRecord.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        if !self.expires.nil?
          if self.quantity.nil? || self.quantity > 0
            User.current_user.primary_identity.calendars.each do |calendar|
              CalendarItem.create_calendar_item(
                identity: User.current_user.primary_identity,
                calendar: calendar,
                model: self.class,
                calendar_item_time: self.expires,
                reminder_threshold_amount: DEFAULT_PERISHABLE_FOODS_THRESHOLD_SECONDS,
                reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
                model_id: id
              )
            end
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
