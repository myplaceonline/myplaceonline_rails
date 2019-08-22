FactoryBot.define do
  factory :notification do
    notification_subject { "MyString" }
    notification_text { "MyText" }
    notification_type { 1 }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-08-22 12:49:47" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
