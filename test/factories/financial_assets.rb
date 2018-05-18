FactoryBot.define do
  factory :financial_asset do
    asset_name "MyString"
    asset_value "9.99"
    asset_location "MyString"
    notes "MyText"
    visit_count 1
    archived "2018-05-18 08:46:53"
    rating 1
    is_public false
    identity nil
  end
end
