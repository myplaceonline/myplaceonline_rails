FactoryGirl.define do
  factory :check do
    description "MyString"
    notes "MyText"
    amount "9.99"
    contact nil
    company nil
    deposit_date "2017-01-22"
    received_date "2017-01-22"
    bank_account nil
    visit_count 1
    archived "2017-01-22 03:19:23"
    rating 1
    identity nil
  end
end
