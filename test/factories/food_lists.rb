FactoryBot.define do
  factory :food_list do
    food_list_name "MyString"
    notes "MyText"
    visit_count 1
    archived "2018-02-03 17:51:18"
    rating 1
    is_public false
    identity nil
  end
end
