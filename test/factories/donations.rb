FactoryBot.define do
  factory :donation do
    donation_name "MyString"
    donation_date "2017-01-16"
    amount "9.99"
    location nil
    notes "MyText"
    visit_count 1
    archived "2017-01-16 00:40:00"
    rating 1
    identity nil
  end
end
