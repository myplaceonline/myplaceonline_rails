FactoryBot.define do
  factory :security_token do
    security_token_value "MyString"
    notes "MyText"
    visit_count 1
    archived "2018-02-03 21:08:59"
    rating 1
    is_public false
    identity nil
  end
end
