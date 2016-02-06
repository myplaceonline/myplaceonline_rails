class Event < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_EVENT_THRESHOLD_SECONDS = 15.days

  validates :event_name, presence: true
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def display
    event_name
  end
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(event_pictures, [I18n.t("myplaceonline.category.events"), display])
  end

  has_many :event_pictures, :dependent => :destroy
  accepts_nested_attributes_for :event_pictures, allow_destroy: true, reject_if: :all_blank

  def self.calendar_item_display(calendar_item)
    event = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.events.upcoming",
      name: event.display,
      delta: Myp.time_difference_in_general_human(TimeDifference.between(User.current_user.time_now, event.event_time).in_general)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !event_time.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            event_time,
            (calendar.event_threshold_seconds || DEFAULT_EVENT_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id,
            expire_amount: 2.days.seconds.to_i,
            expire_type: Calendar::DEFAULT_REMINDER_TYPE
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
