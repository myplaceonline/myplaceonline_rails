FactoryBot.define do
  factory :doctor_visit do
    visit_date "2015-08-30"
notes "MyText"
doctor nil
health_insurance nil
paid "9.99"
physical false
owner nil
  end

end
