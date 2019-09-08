FactoryBot.define do
  factory :hospital do
    location { nil }
    health_insurance { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-09-07 17:06:44" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
