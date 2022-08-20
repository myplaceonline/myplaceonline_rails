FactoryBot.define do
  factory :merchant_account do
    merchant_account_name { "MyString" }
    limit_daily { "9.99" }
    limit_monthly { "9.99" }
    currencies_accepted { "MyText" }
    ship_to_countries { "MyText" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2022-08-20 16:20:29" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
