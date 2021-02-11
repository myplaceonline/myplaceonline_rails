FactoryBot.define do
  factory :lock do
    lock_name { "MyString" }
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-02-11 10:01:37" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
