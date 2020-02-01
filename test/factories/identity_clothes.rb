FactoryBot.define do
  factory :identity_clothe do
    identity { nil }
    parent_identity { nil }
    archived { "2020-02-01 14:23:08" }
    rating { 1 }
    is_public { false }
    when_date { "2020-02-01" }
    clothes { "MyText" }
  end
end
