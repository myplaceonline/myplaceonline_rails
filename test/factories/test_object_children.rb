FactoryBot.define do
  factory :test_object_child do
    test_object nil
    test_object_child_name "MyString"
    notes "MyText"
    visit_count 1
    archived "2017-01-22 02:36:59"
    rating 1
    identity nil
  end
end
