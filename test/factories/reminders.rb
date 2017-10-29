FactoryBot.define do
  factory :reminder do
    start_time "2017-09-25 23:22:14"
    reminder_threshold_amount 1
    reminder_threshold_type 1
    expire_amount 1
    expire_type 1
    repeat_amount 1
    repeat_type 1
    max_pending 1
    notes "MyText"
    visit_count 1
    archived "2017-09-25 23:22:14"
    rating 1
    identity nil
  end
end
