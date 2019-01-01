FactoryBot.define do
  factory :art_file do
    art { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
