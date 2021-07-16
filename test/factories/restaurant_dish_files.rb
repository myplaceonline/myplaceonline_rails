FactoryBot.define do
  factory :restaurant_dish_file do
    restaurant_dish { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
