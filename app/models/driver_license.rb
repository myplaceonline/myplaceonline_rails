class DriverLicense < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  DEFAULT_THRESHOLD_SECONDS = 30.days.seconds

  validates :driver_license_identifier, presence: true
  
  def display
    Myp.appendstrwrap(driver_license_identifier, sub_region1_name)
  end
  
  child_property(name: :address, model: Location)
  
  child_files

  def self.skip_check_attributes
    ["region"]
  end

  def region_name
    if !region.blank?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
  
  def sub_region1_name
    if !region.blank? && !sub_region1.blank?
      reg = Carmen::Country.coded(region)
      if reg.subregions.length > 0
        subregion = reg.subregions.coded(sub_region1)
        if !subregion.nil?
          subregion.name
        else
          sub_region1
        end
      else
        sub_region1
      end
    else
      nil
    end
  end

  def self.calendar_item_display(calendar_item)
    x = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.driver_licenses.expiring",
      name: x.display,
      delta: Myp.time_delta(x.driver_license_expires)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      ApplicationRecord.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: id)
        
        if !self.driver_license_expires.nil?
          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: self.driver_license_expires,
              reminder_threshold_amount: DEFAULT_THRESHOLD_SECONDS,
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
    CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: self.id)
  end
end
