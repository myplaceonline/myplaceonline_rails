FactoryGirl.define do
  factory :job_review do
    job nil
    identity nil
    review_date "2016-08-12"
    company_score "MyString"
    contact nil
    notes "MyText"
  end
end
