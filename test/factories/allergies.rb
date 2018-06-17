FactoryBot.define do
  factory :allergy do
    allergy_description "MyString"
    started "2018-06-17"
    ended "2018-06-17"
    notes "MyText"
    visit_count 1
    archived "2018-06-17 14:42:57"
    rating 1
    is_public false
    identity nil
  end
end
