FactoryBot.define do
  factory :mechanic do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-02-19 16:00:54" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
