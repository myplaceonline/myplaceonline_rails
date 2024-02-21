FactoryBot.define do
  factory :google_place_search_result do
    search { "MyString" }
    placeid { "MyString" }
    jsonresult { "MyText" }
  end
end
