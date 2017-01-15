FactoryGirl.define do
  factory :vehicle_registration do
    vehicle nil
    registration_source "MyString"
    registration_date "2017-01-15"
    amount "9.99"
    visit_count 1
    archived "2017-01-15 11:09:16"
    rating 1
    identity nil
  end
end
