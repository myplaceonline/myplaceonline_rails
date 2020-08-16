FactoryBot.define do
  factory :tennis_court do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-08-15 18:36:36" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
