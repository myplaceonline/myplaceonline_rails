FactoryGirl.define do
  factory :problem_report do
    report_name "MyString"
    notes "MyText"
    visit_count 1
    identity nil
  end
end
