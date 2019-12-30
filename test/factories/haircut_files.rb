FactoryBot.define do
  factory :haircut_file do
    haircut { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
