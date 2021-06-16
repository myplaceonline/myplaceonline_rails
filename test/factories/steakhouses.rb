FactoryBot.define do
  factory :steakhouse do
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-06-15 17:54:44" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
