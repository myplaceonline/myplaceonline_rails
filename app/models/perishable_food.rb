class PerishableFood < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_PERISHABLE_FOODS_THRESHOLD_SECONDS = 30.days.seconds

  validates :food, presence: true
  
  belongs_to :food
  accepts_nested_attributes_for :food, allow_destroy: true, reject_if: :all_blank
  allow_existing :food
  
  def display
    food.display
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
      if !self.expires.nil?
        ActiveRecord::Base.transaction do
          CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
          
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
