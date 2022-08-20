FactoryBot.define do
  factory :life_change_file do
    life_change { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
