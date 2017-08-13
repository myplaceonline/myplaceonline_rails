FactoryGirl.define do
  factory :blog do
    blog_name "MyString"
    notes "MyText"
    visit_count 1
    archived "2017-08-13 15:31:26"
    rating 1
    identity nil
  end
end
