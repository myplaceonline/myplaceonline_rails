FactoryBot.define do
  factory :mrobble do
    mrobble_name { "MyString" }
    mrobble_link { "MyString" }
    stopped_watching_time { "MyString" }
    finished { false }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-06-19 07:32:38" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
