FactoryBot.define do
  factory :video do
    video_name { "MyString" }
    video_link { "MyString" }
    stopped_watching_time { "MyString" }
    finished { false }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-08-01 21:26:46" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
