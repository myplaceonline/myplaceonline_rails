FactoryBot.define do
  factory :park do
    location { nil }
    allows_drinking { false }
    drinking_times { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-07-03 17:57:33" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
