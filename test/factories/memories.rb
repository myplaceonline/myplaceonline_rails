FactoryGirl.define do
  factory :memory do
    memory_name "MyString"
    memory_date "2017-02-12"
    notes "MyText"
    visit_count 1
    archived "2017-02-12 20:40:12"
    rating 1
    identity nil
  end
end
