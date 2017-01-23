FactoryGirl.define do
  factory :test_score do
    test_score_name "MyString"
    test_score_date "2017-01-23"
    notes "MyText"
    visit_count 1
    archived "2017-01-23 15:17:16"
    rating 1
    identity nil
  end
end
