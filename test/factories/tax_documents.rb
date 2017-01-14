FactoryGirl.define do
  factory :tax_document do
    tax_document_form_name "MyString"
    tax_document_description "MyString"
    notes "MyText"
    received_date "2017-01-13"
    fiscal_year 1
    amount "9.99"
    visit_count 1
    archived "2017-01-13 12:57:27"
    rating 1
    identity nil
  end
end
