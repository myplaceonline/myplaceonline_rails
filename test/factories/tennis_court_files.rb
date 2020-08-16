FactoryBot.define do
  factory :tennis_court_file do
    tennis_court { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
