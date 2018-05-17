FactoryBot.define do
  factory :wallet do
    wallet_name "MyString"
    currency_type 1
    balance "9.99"
    password nil
    notes "MyText"
    visit_count 1
    archived "2018-05-16 18:32:20"
    rating 1
    is_public false
    identity nil
  end
end
