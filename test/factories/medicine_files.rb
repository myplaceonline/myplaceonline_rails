FactoryBot.define do
  factory :medicine_file do
    medicine { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
