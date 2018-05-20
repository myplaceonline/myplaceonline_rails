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
      result = Myp.appendstrwrap(flight_name, Myp.display_datetime_short_year(flight_legs[0].depart_time, User.current_user))
      x = self.transport_time
      if !x.nil?
        result = Myp.appendstr(result, I18n.t("myplaceonline.flights.alert_transport") + " @ " + Myp.display_time(x, User.current_user, :short_time), ", ")
      end
      x = self.start_time
      if !x.nil?
        result = Myp.appendstr(result, I18n.t("myplaceonline.flights.alert_start") + " @ " + Myp.display_time(x, User.current_user, :short_time), ", ")
      end
      result
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
            expire_amount: 1.days.seconds.to_i,
            expire_type: Calendar::DEFAULT_REMINDER_TYPE,
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

  def self.calendar_item_display(calendar_item)
    flight = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.flights.checkin",
      name: flight.display,
      delta: Myp.time_delta(flight.flight_start_date)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    flight = calendar_item.find_model_object
    "/flights/#{flight.id}"
  end
  
  def main_timings
    [
      {
        name: "myplaceonline.flights.timing_names.transportation",
        time: 30.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.transportation_buffer",
        time: 15.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.checkin",
        time: 15.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.security",
        time: 15.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.board",
        time: 45.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.airport_buffer",
        time: 15.minutes,
      },
    ]
  end
  
  def main_timing
    total = 0.seconds
    self.main_timings.each do |x|
      total = total + x[:time]
    end
    total
  end
  
  def prepare_timings
    [
      {
        name: "myplaceonline.flights.timing_names.shower",
        time: 15.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.eat",
        time: 15.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.brush_teeth",
        time: 5.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.pack",
        time: 30.minutes,
      },
      {
        name: "myplaceonline.flights.timing_names.prepare_buffer",
        time: 15.minutes,
      },
    ]
  end
  
  def prepare_timing
    total = 0.seconds
    self.main_timings.each do |x|
      total = total + x[:time]
    end
    total
  end
  
  def transport_time
    x = self.first_flight_leg
    if !x.nil? && !x.depart_time.nil?
      x.depart_time - main_timing
    else
      nil
    end
  end
  
  def start_time
    x = self.first_flight_leg
    if !x.nil? && !x.depart_time.nil?
      x.depart_time - main_timing - prepare_timing
    else
      nil
    end
  end
end
