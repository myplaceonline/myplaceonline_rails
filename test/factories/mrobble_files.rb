FactoryBot.define do
  factory :mrobble_file do
    mrobble { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
