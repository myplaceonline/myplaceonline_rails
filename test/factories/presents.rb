FactoryBot.define do
  factory :present do
    present_name "MyString"
    present_given "2018-08-02"
    present_purchased "2018-08-02"
    present_amount "9.99"
    contact nil
    notes "MyText"
    visit_count 1
    archived "2018-08-02 18:15:27"
    rating 1
    is_public false
    identity nil
  end
end
