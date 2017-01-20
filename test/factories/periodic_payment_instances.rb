FactoryGirl.define do
  factory :periodic_payment_instance do
    periodic_payment nil
    payment_date "2017-01-20"
    amount "9.99"
    notes "MyText"
    visit_count 1
    archived "2017-01-20 00:46:17"
    rating 1
    identity nil
  end
end
