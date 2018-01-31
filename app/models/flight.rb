class Flight < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :flight_name, presence: true
  
  child_properties(name: :flight_legs, sort: "depart_time ASC, position ASC")

  child_property(name: :website)

  def display
    Myp.appendstrwrap(flight_name, Myp.display_datetime_short_year(flight_start_date, User.current_user))
  end
  
  def display_with_first_leg
    if flight_legs.length == 0
      display
    else
      Myp.appendstrwrap(flight_name, Myp.display_datetime_short_year(flight_legs[0].depart_time, User.current_user))
    end
  end
  
  def first_flight_leg
    legs = self.flight_legs
    if !legs.nil? && legs.length > 0
      legs[0]
    else
      nil
    end
  end

  def last_flight_leg
    legs = self.flight_legs
    if !legs.nil? && legs.length > 0
      legs[legs.length - 1]
    else
      nil
    end
  end

  def trip_info_url
    if !self.confirmation_number.blank?
      "https://viewtrip.travelport.com/#!/itinerary?loc=#{self.confirmation_number}&lName=#{ERB::Util.url_encode(User.current_user.current_identity.last_name)}"
    else
      nil
    end
  end
  
  def earliest_checkin_time
    24.hours
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ApplicationRecord.transaction do
      self.on_after_destroy
      if !self.flight_start_date.nil?
        User.current_user.current_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            identity: User.current_user.current_identity,
            calendar: calendar,
            model: Flight,
            model_id: self.id,
            calendar_item_time: self.flight_start_date,
            reminder_threshold_amount: self.earliest_checkin_time.seconds,
            reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.current_identity,
      Flight,
      model_id: self.id,
    )
  end
end
