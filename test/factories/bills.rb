FactoryGirl.define do
  factory :bill do
    bill_name "MyString"
    bill_date "2017-01-27"
    amount "9.99"
    notes "MyText"
    visit_count 1
    archived "2017-01-27 20:39:32"
    rating 1
    identity nil
  end
end
