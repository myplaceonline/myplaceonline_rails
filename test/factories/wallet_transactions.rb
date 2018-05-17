FactoryBot.define do
  factory :wallet_transaction do
    wallet nil
    transaction_time "2018-05-16 19:03:51"
    transaction_id "MyString"
    contact nil
    exchange_currency 1
    exchange_rate "9.99"
    fee "9.99"
    notes "MyText"
    visit_count 1
    archived "2018-05-16 19:03:51"
    rating 1
    is_public false
    identity nil
  end
end
