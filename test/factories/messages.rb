FactoryBot.define do
  factory :message do
    body "MyText"
    copy_self false
    message_category "MyString"
    draft false
    personalize false
    visit_count 1
    identity nil
  end
end
