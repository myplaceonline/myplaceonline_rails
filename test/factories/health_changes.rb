FactoryBot.define do
  factory :health_change do
    change_name { "MyString" }
    change_date { "2020-09-20" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-09-20 07:21:49" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
