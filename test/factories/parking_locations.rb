FactoryBot.define do
  factory :parking_location do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-05-15 23:03:51" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
