FactoryGirl.define do
  factory :perishable_food do
    food nil
    purchased "2016-10-30"
    expires "2016-10-30"
    storage_location "MyString"
    notes "MyText"
    visit_count 1
    archived "2016-10-30 12:38:31"
    rating 1
    identity nil
  end
end
