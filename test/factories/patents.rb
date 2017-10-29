FactoryBot.define do
  factory :patent do
    patent_name "MyString"
    patent_number "MyString"
    authors "MyString"
    region "MyString"
    filed_date "2017-01-29"
    publication_date "2017-01-29"
    patent_abstract "MyText"
    patent_text "MyText"
    notes "MyText"
    visit_count 1
    archived "2017-01-29 18:02:12"
    rating 1
    identity nil
  end
end
