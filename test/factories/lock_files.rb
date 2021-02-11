FactoryBot.define do
  factory :lock_file do
    lock { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
