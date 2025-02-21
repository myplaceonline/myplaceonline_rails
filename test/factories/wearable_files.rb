FactoryBot.define do
  factory :wearable_file do
    wearable { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
