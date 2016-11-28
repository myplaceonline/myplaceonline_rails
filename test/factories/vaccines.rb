FactoryGirl.define do
  factory :vaccine do
    vaccine_name "MyString"
    injection_date "2016-11-27"
    notes "MyText"
    visit_count 1
    archived "2016-11-27 20:03:34"
    rating 1
    identity nil
  end
end
