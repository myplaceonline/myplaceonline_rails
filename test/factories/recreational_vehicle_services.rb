FactoryGirl.define do
  factory :recreational_vehicle_service do
    recreational_vehicle nil
    notes "MyText"
    short_description "MyString"
    date_due "2016-10-28"
    date_serviced "2016-10-28"
    service_location "MyString"
    cost "9.99"
    visit_count 1
    archived "2016-10-28 10:19:16"
    rating 1
    identity nil
  end
end
