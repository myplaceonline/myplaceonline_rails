FactoryGirl.define do
  factory :surgery do
    surgery_name "MyString"
    surgery_date "2017-02-19"
    hospital nil
    doctor nil
    notes "MyText"
    visit_count 1
    archived "2017-02-19 20:36:37"
    rating 1
    identity nil
  end
end
