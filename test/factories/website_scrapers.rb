FactoryGirl.define do
  factory :website_scraper do
    scraper_name "MyString"
    website_url "MyString"
    notes "MyText"
    visit_count 1
    archived "2017-06-07 21:16:23"
    rating 1
    identity nil
  end
end
