FactoryBot.define do
  factory :barbecue do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-06-04 14:48:44" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
