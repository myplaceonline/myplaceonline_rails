FactoryBot.define do
  factory :dentist_visit_file do
    dentist_visit { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
