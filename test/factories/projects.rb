FactoryBot.define do
  factory :project do
    project_name "MyString"
    notes "MyText"
    start_date "2016-06-21"
    end_date "2016-06-21"
    visit_count 1
    identity nil
  end
end
