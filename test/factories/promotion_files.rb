FactoryBot.define do
  factory :promotion_file do
    promotion { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
