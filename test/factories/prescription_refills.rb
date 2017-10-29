FactoryBot.define do
  factory :prescription_refill do
    prescription nil
    refill_date "2017-01-15"
    location nil
    notes "MyText"
    visit_count 1
    archived "2017-01-15 13:33:02"
    rating 1
    identity nil
  end
end
