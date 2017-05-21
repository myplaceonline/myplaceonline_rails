FactoryGirl.define do
  factory :sickness do
    sickness_start "2017-05-20"
    sickness_end "2017-05-20"
    coughing false
    sneezing false
    throwing_up false
    fever false
    runny_nose false
    notes "MyText"
    visit_count 1
    archived "2017-05-20 10:54:08"
    rating 1
    identity nil
  end
end
