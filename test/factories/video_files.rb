FactoryBot.define do
  factory :video_file do
    video { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
