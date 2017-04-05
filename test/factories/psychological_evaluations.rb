FactoryGirl.define do
  factory :psychological_evaluation do
    psychological_evaluation_name "MyString"
    evaluation_date "2017-04-05"
    evaluator nil
    score "9.99"
    evaluation "MyText"
    visit_count 1
    archived "2017-04-05 12:17:16"
    rating 1
    identity nil
  end
end
