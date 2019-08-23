FactoryBot.define do
  factory :notification_preference do
    notification_type { 1 }
    notification_category { "MyString" }
    notifications_enabled { false }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-08-23 15:28:32" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
