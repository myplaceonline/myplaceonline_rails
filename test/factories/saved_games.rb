FactoryBot.define do
  factory :saved_game do
    game_name "MyString"
    game_time "2018-07-02 21:19:14"
    contact nil
    notes "MyText"
    visit_count 1
    archived "2018-07-02 21:19:14"
    rating 1
    is_public false
    identity nil
  end
end
