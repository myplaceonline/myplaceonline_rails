FactoryBot.define do
  factory :meme do
    meme_name { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2021-05-28 13:06:13" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
