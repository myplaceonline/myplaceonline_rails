FactoryBot.define do
  factory :life_change do
    life_change_title { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2022-08-20 14:42:34" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
