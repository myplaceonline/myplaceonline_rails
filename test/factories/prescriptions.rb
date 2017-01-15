FactoryGirl.define do
  factory :prescription do
    prescription_name "MyString"
    prescription_date "2017-01-15"
    notes "MyText"
    doctor nil
    visit_count 1
    archived "2017-01-15 13:04:03"
    rating 1
    identity nil
  end
end
