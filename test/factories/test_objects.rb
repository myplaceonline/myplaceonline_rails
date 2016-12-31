FactoryGirl.define do
  factory :test_object do
    test_object_name "MyString"
    notes "MyText"
    visit_count 1
    archived "2016-12-31 04:48:05"
    rating 1
    identity nil
  end
end
