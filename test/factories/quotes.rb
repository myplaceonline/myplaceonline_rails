FactoryBot.define do
  factory :quote do
    quote_text "MyText"
    quote_date "2017-01-13"
    visit_count 1
    archived "2017-01-13 16:16:35"
    rating 1
    identity nil
  end
end
