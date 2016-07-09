FactoryGirl.define do
  factory :flight_leg do
    flight nil
    flight_number 1
    flight_company nil
    depart_location nil
    depart_time "2016-07-08 20:55:31"
    arrive_location nil
    arrive_time "2016-07-08 20:55:31"
    seat_number "MyString"
    position 1
    identity nil
  end
end
