FactoryGirl.define do
  factory :periodic_payment do
    periodic_payment_name "MyString"
notes "MyText"
started "2015-06-01"
ended "2015-06-01"
date_period 1
payment_amount "9.99"
identity nil
  end

end
