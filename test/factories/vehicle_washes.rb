FactoryBot.define do
  factory :vehicle_wash do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-11-16 09:46:46" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
