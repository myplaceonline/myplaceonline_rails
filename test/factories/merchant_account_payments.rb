FactoryBot.define do
  factory :merchant_account_payment do
    merchant_account { nil }
    payment_name { "MyString" }
    amount_per_payment { "9.99" }
    percent_total { "9.99" }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
