FactoryBot.define do
  factory :basketball_court do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-08-15 18:36:10" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
