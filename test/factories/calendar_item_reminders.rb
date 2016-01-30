FactoryGirl.define do
  factory :calendar_item_reminder do
    threshold_seconds 1
repeat_seconds 1
calendar_item nil
identity nil
  end

end
