FactoryBot.define do
  factory :soccer_field_file do
    soccer_field { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
