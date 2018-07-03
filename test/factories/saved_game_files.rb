FactoryBot.define do
  factory :saved_game_file do
    saved_game nil
    identity_file nil
    identity nil
    position 1
    is_public false
  end
end
