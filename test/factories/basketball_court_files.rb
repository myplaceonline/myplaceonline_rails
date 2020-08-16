FactoryBot.define do
  factory :basketball_court_file do
    basketball_court { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
