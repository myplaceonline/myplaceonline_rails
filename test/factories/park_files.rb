FactoryBot.define do
  factory :park_file do
    park { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
