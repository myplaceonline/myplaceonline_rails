FactoryBot.define do
  factory :bank_account_file do
    bank_account { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
