FactoryBot.define do
  factory :meme_file do
    meme { nil }
    identity_file { nil }
    identity { nil }
    position { 1 }
    is_public { false }
  end
end
