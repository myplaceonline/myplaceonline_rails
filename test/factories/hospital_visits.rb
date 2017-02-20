FactoryGirl.define do
  factory :hospital_visit do
    hospital_visit_purpose "MyString"
    hospital_visit_date "2017-02-19"
    hospital nil
    notes "MyText"
    visit_count 1
    archived "2017-02-19 21:58:12"
    rating 1
    identity nil
  end
end
