class Membership < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :name, presence: true
  
  child_property(name: :periodic_payment)
  
  child_property(name: :password)

  def display
    name
  end

  def self.calendar_item_display(calendar_item)
    obj = calendar_item.find_model_object
    now = User.current_user.time_now
    if obj.end_date > now
      message_type = "myplaceonline.general.expires"
    else
      message_type = "myplaceonline.general.expired"
    end
    I18n.t(
      message_type,
      display: obj.display,
      delta: Myp.time_delta(obj.end_date)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      ApplicationRecord.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        if !end_date.nil?
          User.current_user.primary_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.primary_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: end_date,
              reminder_threshold_amount: (calendar.general_threshold_seconds || Calendar::DEFAULT_REMINDER_AMOUNT),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end

  child_properties(name: :membership_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(membership_files, [I18n.t("myplaceonline.category.memberships"), display])
  end
end
