FactoryGirl.define do
  factory :dentist_visit do
    visit_date "2015-08-30"
cavities 1
notes "MyText"
dentist nil
dental_insurance nil
paid "9.99"
cleaning false
owner nil
  end

end
