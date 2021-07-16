FactoryBot.define do
  factory :restaurant_dish do
    dish_name { "MyString" }
    restaurant { nil }
    cost { "9.99" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-07-15 17:02:42" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
