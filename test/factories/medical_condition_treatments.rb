FactoryGirl.define do
  factory :medical_condition_treatment do
    identity nil
    medical_condition nil
    treatment_date "2016-08-02"
    notes "MyText"
    doctor nil
  end
end
