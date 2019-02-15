FactoryBot.define do
  factory :computer_file do
    computer { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
