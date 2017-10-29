FactoryBot.define do
  factory :paid_tax do
    paid_tax_date "2017-03-12"
    donations "9.99"
    federal_refund "9.99"
    state_refund "9.99"
    service_fee "9.99"
    notes "MyText"
    password nil
    visit_count 1
    archived "2017-03-12 22:40:49"
    rating 1
    identity nil
  end
end
