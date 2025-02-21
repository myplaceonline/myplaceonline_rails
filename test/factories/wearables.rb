FactoryBot.define do
  factory :wearable do
    name { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2025-02-21 15:35:07" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
