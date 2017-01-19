class Flight < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :flight_name, presence: true
  
  child_properties(name: :flight_legs, sort: "depart_time ASC, position ASC")

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
end
