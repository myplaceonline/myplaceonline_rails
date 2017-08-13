FactoryGirl.define do
  factory :import do
    import_name "MyString"
    import_type 1
    notes "MyText"
    visit_count 1
    archived "2017-08-13 14:55:44"
    rating 1
    identity nil
  end
end
