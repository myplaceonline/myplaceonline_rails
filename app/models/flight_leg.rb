class FlightLeg < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :flight

  child_property(name: :flight_company, model: Company)

  child_property(name: :depart_location, model: Location)

  child_property(name: :arrival_location, model: Location)
  
  def display
    result = nil
    if !self.flight_company.nil?
      result = self.flight_company.display
    end
    result = Myp.appendstr(result, "#{self.flight_number}")
    
    if !self.depart_airport_code.blank? || !self.depart_time.nil?
      result = Myp.appendstr(result, "#{I18n.t("myplaceonline.flight_legs.from").downcase}")
    end
    
    result = Myp.appendstr(result, self.depart_airport_code)
    
    if !self.depart_time.nil?
      result = Myp.appendstr(result, "@")
    end
    
    result = Myp.appendstr(result, Myp.display_datetime_short_year(self.depart_time, User.current_user))
    
    if !self.arrival_airport_code.blank? || !self.arrive_time.nil?
      result = Myp.appendstr(result, "#{I18n.t("myplaceonline.flight_legs.to").downcase}")
    end
    
    result = Myp.appendstr(result, self.arrival_airport_code)
    
    if !self.arrive_time.nil?
      result = Myp.appendstr(result, "@")
    end
    
    result = Myp.appendstr(result, Myp.display_datetime_short_year(self.arrive_time, User.current_user))
    result
  end
end
