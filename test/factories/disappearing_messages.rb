FactoryBot.define do
  factory :disappearing_message do
    name { "MyString" }
    uuididentifier { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2026-01-14 20:58:23" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
