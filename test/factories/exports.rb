FactoryBot.define do
  factory :export do
    export_name "MyString"
    export_type 1
    export_status 1
    export_progress "MyText"
    notes "MyText"
    visit_count 1
    archived "2018-02-03 23:57:52"
    rating 1
    is_public false
    identity nil
  end
end
