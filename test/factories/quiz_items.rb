FactoryBot.define do
  factory :quiz_item do
    quiz nil
    quiz_question "MyString"
    quiz_answer "MyString"
    link "MyString"
    notes "MyText"
    visit_count 1
    archived "2018-08-05 14:42:58"
    rating 1
    is_public false
    identity nil
  end
end
