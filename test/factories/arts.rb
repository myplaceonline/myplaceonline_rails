FactoryBot.define do
  factory :art do
    art_name { "MyString" }
    art_source { "MyString" }
    art_date { "2018-12-31" }
    art_link { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2018-12-31 15:49:19" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
