FactoryBot.define do
  factory :haircut do
    haircut_time { "2019-12-30 14:55:06" }
    total_cost { "9.99" }
    cutter { nil }
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-12-30 14:55:06" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
