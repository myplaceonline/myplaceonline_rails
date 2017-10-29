FactoryBot.define do
  factory :item do
    item_name "MyString"
    notes "MyText"
    item_location "MyString"
    cost "9.99"
    acquired "2016-11-03"
    visit_count 1
    archived "2016-11-03 18:45:57"
    rating 1
    identity nil
  end
end
