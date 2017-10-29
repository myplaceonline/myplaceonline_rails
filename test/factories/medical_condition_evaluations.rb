FactoryBot.define do
  factory :medical_condition_evaluation do
    medical_condition nil
    notes "MyText"
    location nil
    evaluation_datetime "2017-01-13 22:56:54"
    visit_count 1
    archived "2017-01-13 22:56:54"
    rating 1
    identity nil
  end
end
