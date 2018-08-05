FactoryBot.define do
  factory :quiz do
    quiz_name "MyString"
    notes "MyText"
    visit_count 1
    archived "2018-08-05 13:55:31"
    rating 1
    is_public false
    identity nil
  end
end
