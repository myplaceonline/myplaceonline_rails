FactoryBot.define do
  factory :reputation_report do
    short_description "MyString"
    story "MyText"
    notes "MyText"
    visit_count 1
    archived "2017-11-19 22:13:40"
    rating 1
    is_public false
    identity nil
  end
end
