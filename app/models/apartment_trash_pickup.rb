class ApartmentTrashPickup < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_TRASH_PICKUP_THRESHOLD_SECONDS = 2.days

  TRASH_TYPES = [
    ["myplaceonline.trash.type_general", 0],
    ["myplaceonline.trash.type_recycling", 1]
  ]
  
  belongs_to :apartment
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank
  validates_presence_of :repeat

  validates :trash_type, presence: true

  def self.calendar_item_display(calendar_item)
    trash_pickup = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.apartments.trash_pickup_reminder",
      trash_type: Myp.get_select_name(trash_pickup.trash_type, ApartmentTrashPickup::TRASH_TYPES),
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    trash_pickup = calendar_item.find_model_object
    "/apartments/#{trash_pickup.apartment.id}"
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    Repeat.create_calendar_reminders(
      self,
      "trash_pickup_threshold_seconds",
      DEFAULT_TRASH_PICKUP_THRESHOLD_SECONDS,
      Calendar::DEFAULT_REMINDER_TYPE
    )
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
