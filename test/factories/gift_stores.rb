FactoryBot.define do
  factory :gift_store do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-05-28 15:18:05" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
