FactoryBot.define do
  factory :merchant_account_file do
    merchant_account { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
