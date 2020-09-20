FactoryBot.define do
  factory :health_change_file do
    health_change { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
