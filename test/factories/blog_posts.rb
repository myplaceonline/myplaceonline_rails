FactoryGirl.define do
  factory :blog_post do
    blog nil
    blog_post_title "MyString"
    post "MyText"
    visit_count 1
    archived "2017-08-13 15:49:58"
    rating 1
    identity nil
  end
end
