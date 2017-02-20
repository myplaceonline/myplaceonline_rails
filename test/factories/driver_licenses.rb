FactoryGirl.define do
  factory :driver_license do
    driver_license_identifier "MyString"
    driver_license_expires "2017-02-19"
    driver_license_issued "2017-02-19"
    sub_region1 "MyString"
    address nil
    notes "MyText"
    visit_count 1
    archived "2017-02-19 21:33:27"
    rating 1
    identity nil
  end
end
