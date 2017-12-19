FactoryBot.define do
  factory :site_invoice do
    invoice_time "2017-12-18 21:14:56"
    invoice_amount "9.99"
    model_class "MyString"
    model_id 1
    invoice_status 1
    notes "MyText"
    visit_count 1
    archived "2017-12-18 21:14:56"
    rating 1
    is_public false
    identity nil
  end
end
