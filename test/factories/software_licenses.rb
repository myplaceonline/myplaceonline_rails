FactoryGirl.define do
  factory :software_license do
    license_name "MyString"
    license_value "9.99"
    license_purchase_date "2017-02-12"
    license_key "MyText"
    notes "MyText"
    visit_count 1
    archived "2017-02-12 20:54:20"
    rating 1
    identity nil
  end
end
