class Flight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :flight_name, presence: true
  
  has_many :flight_legs, -> { order('depart_time ASC, position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :flight_legs, allow_destroy: true, reject_if: :all_blank

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
