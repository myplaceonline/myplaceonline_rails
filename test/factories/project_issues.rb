FactoryBot.define do
  factory :project_issue do
    project nil
    identity nil
    position 1
    issue_name "MyString"
    notes "MyText"
  end
end
